// features/expense/presentation/views/add_expense_dialog.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../account_ledger/presentation/provider/account_ledger_providers.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_providers.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _remarksController = TextEditingController();
  late DateTime _selectedDate;

  int? _selectedHeadId;
  int? _selectedAccountId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _selectedHeadId == null ||
        _selectedAccountId == null)
      return;

    setState(() => _isLoading = true);

    final newExpense = Expense(
      id: 0,
      expenseHeadId: _selectedHeadId!,
      amount: double.parse(_amountController.text.trim()),
      remarks: _remarksController.text.trim(),
      date: _selectedDate,
    );

    try {
      await ref
          .read(expenseRepositoryProvider)
          .addExpense(newExpense, accountId: _selectedAccountId);
      // Invalidate the provider so it fetches the fresh 1.5-day list from the DB
      ref.invalidate(recentExpensesProvider);
      ref.invalidate(monthlyInsightsProvider);
      ref.invalidate(getAllAccountsProvider); // Invalidates account balances
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the heads so we can populate the dropdown
    final headsAsync = ref.watch(expenseHeadsProvider);
    final accountsAsync = ref.watch(getAllAccountsProvider);

    return AlertDialog(
      title: const Text('Record Expense'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('dd MMM yyyy').format(_selectedDate),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                headsAsync.when(
                  data: (heads) {
                    if (heads.isEmpty) {
                      return const Text(
                        'Please add an Expense Head first.',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    return DropdownButtonFormField<int>(
                      initialValue: _selectedHeadId,
                      decoration: const InputDecoration(
                        labelText: 'Expense Head',
                        border: OutlineInputBorder(),
                      ),
                      items: heads
                          .map(
                            (h) => DropdownMenuItem(
                              value: h.id,
                              child: Text(h.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedHeadId = val),
                      validator: (val) =>
                          val == null ? 'Please select a head' : null,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error loading heads: $e'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: 'PKR ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                accountsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error loading accounts: $e'),
                  data: (accounts) {
                    // Usually cash, but let user choose any account
                    if (accounts.isEmpty) {
                      return const Text(
                        'Please create an account first.',
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    if (accounts.length == 1 && _selectedAccountId == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _selectedAccountId = accounts.first.id;
                        });
                      });
                    }

                    return DropdownButtonFormField<int>(
                      initialValue: _selectedAccountId,
                      decoration: const InputDecoration(
                        labelText: 'Paid From Account *',
                        border: OutlineInputBorder(),
                      ),
                      items: accounts
                          .map(
                            (a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(
                                '${a.accountTitle} (${a.accountType})',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedAccountId = val),
                      validator: (val) =>
                          val == null ? 'Please select an account' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _remarksController,
                  decoration: const InputDecoration(
                    labelText: 'Remarks',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed:
              _isLoading ||
                  _selectedHeadId == null ||
                  _selectedAccountId == null
              ? null
              : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
