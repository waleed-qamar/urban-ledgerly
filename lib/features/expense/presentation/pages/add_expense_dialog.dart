// features/expense/presentation/views/add_expense_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../account_ledger/domain/entities/account_entity.dart';
import '../../../account_ledger/presentation/provider/account_ledger_providers.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_head.dart';
import '../providers/expense_providers.dart';
import '../../../../core/widgets/searchable_dropdown.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  final Expense? expense;

  const AddExpenseDialog({super.key, this.expense});

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
    _selectedDate = widget.expense?.date ?? DateTime.now();

    if (widget.expense != null) {
      _selectedHeadId = widget.expense!.expenseHeadId;
      _remarksController.text = widget.expense!.remarks ?? "";
      _amountController.text = widget.expense!.amount.toString();
    }
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
    if (!_formKey.currentState!.validate() || _selectedHeadId == null) return;

    setState(() => _isLoading = true);

    final amount = double.parse(_amountController.text.trim());

    try {
      if (widget.expense == null) {
        if (_selectedAccountId == null) {
          // Account is required for new expense
          setState(() => _isLoading = false);
          return;
        }

        final newExpense = Expense(
          id: 0,
          expenseHeadId: _selectedHeadId!,
          amount: amount,
          remarks: _remarksController.text.trim(),
          date: _selectedDate,
        );

        await ref
            .read(expenseRepositoryProvider)
            .addExpense(newExpense, accountId: _selectedAccountId);

        ref.invalidate(recentExpensesProvider);
        ref.invalidate(monthlyInsightsProvider);
        ref.invalidate(getAllAccountsProvider);
      } else {
        final updated = Expense(
          id: widget.expense!.id,
          expenseHeadId: _selectedHeadId!,
          amount: amount,
          remarks: _remarksController.text.trim(),
          date: _selectedDate,
        );

        await ref.read(expenseRepositoryProvider).updateExpense(updated);

        ref.invalidate(recentExpensesProvider);
        ref.invalidate(monthlyInsightsProvider);
        ref.invalidate(filteredLedgerProvider);
      }

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

    final isEditing = widget.expense != null;
    final canSubmit =
        !_isLoading &&
        _selectedHeadId != null &&
        (isEditing || _selectedAccountId != null);

    return AlertDialog(
      title: Text(isEditing ? 'Edit Expense' : 'Record Expense'),
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
                    return SearchableDropdown<ExpenseHead>(
                      items: heads,
                      displayStringForOption: (h) => h.name,
                      onSelected: (selected) =>
                          setState(() => _selectedHeadId = selected.id),
                      initialText: _selectedHeadId != null
                          ? heads
                                .where((h) => h.id == _selectedHeadId)
                                .firstOrNull
                                ?.name
                          : null,
                      labelText: 'Expense Head',
                      errorText: _selectedHeadId == null
                          ? 'Please select a head'
                          : null,
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (!isEditing)
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

                      final selectedAcc = _selectedAccountId != null
                          ? accounts
                                .where((a) => a.id == _selectedAccountId)
                                .firstOrNull
                          : null;

                      String formatAccount(AccountEntity a) {
                        final parts = <String>[];
                        if (a.bankName != null && a.bankName!.isNotEmpty) {
                          parts.add(a.bankName!);
                        }
                        parts.add(a.accountTitle);
                        if (a.accountNumber != null &&
                            a.accountNumber!.isNotEmpty) {
                          parts.add('(${a.accountNumber})');
                        }
                        return parts.join(' - ');
                      }

                      return SearchableDropdown<AccountEntity>(
                        items: accounts,
                        displayStringForOption: formatAccount,
                        onSelected: (val) =>
                            setState(() => _selectedAccountId = val.id),
                        initialText: selectedAcc != null
                            ? formatAccount(selectedAcc)
                            : null,
                        labelText: 'Paid From Account *',
                        errorText: _selectedAccountId == null
                            ? 'Please select an account'
                            : null,
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
          onPressed: canSubmit ? _submit : null,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}
