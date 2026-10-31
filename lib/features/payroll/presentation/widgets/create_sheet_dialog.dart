import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import '../providers/payroll_providers.dart';

class CreatePayrollSheetDialog extends ConsumerStatefulWidget {
  const CreatePayrollSheetDialog({super.key});

  @override
  ConsumerState<CreatePayrollSheetDialog> createState() =>
      _CreatePayrollSheetDialogState();
}

class _CreatePayrollSheetDialogState
    extends ConsumerState<CreatePayrollSheetDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyController;
  late final TextEditingController _categoryController;
  late final TextEditingController _titleController;
  late final TextEditingController _operatorNameController;
  late final TextEditingController _amountGivenController;

  late DateTime _cutoffDate;
  String _sheetType = 'kharcha'; // 'kharcha' | 'overtime'
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cutoffDate = DateTime.now();

    _companyController = TextEditingController(
      text: 'Urban Composites/Urban Constructions',
    );
    _categoryController = TextEditingController(text: 'Labour');
    _titleController = TextEditingController(
      text: '${_cutoffDate.day} Kharcha',
    );
    _operatorNameController = TextEditingController();
    _amountGivenController = TextEditingController();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _categoryController.dispose();
    _titleController.dispose();
    _operatorNameController.dispose();
    _amountGivenController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final amountGiven =
        double.tryParse(_amountGivenController.text.trim()) ?? 0.0;

    try {
      final sheetId = await ref.read(payrollRepositoryProvider).createSheet(
            company: _companyController.text.trim(),
            category: _categoryController.text.trim(),
            title: _titleController.text.trim(),
            cutoffDate: _cutoffDate,
            operatorName: _operatorNameController.text.trim().isEmpty
                ? null
                : _operatorNameController.text.trim(),
            amountGiven: amountGiven,
            sheetType: _sheetType,
          );

      ref.invalidate(payrollSheetsProvider);
      if (mounted) {
        Navigator.of(context).pop(sheetId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating sheet: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: const Text('New Payout Sheet'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cutoff Date
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cutoff Date: '
                        '${_cutoffDate.year}-${_cutoffDate.month.toString().padLeft(2, '0')}-${_cutoffDate.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _cutoffDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setState(() {
                            _cutoffDate = picked;
                            final suffix = _sheetType == 'overtime' ? 'Overtime' : 'Kharcha';
                            _titleController.text = '${picked.day} $suffix';
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: const Text('Change Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Sheet Type Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _sheetType,
                  decoration: const InputDecoration(
                    labelText: 'Sheet Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'kharcha',
                      child: Row(
                        children: [
                          Icon(Icons.receipt_long, color: Color(0xFF1E88E5), size: 18),
                          SizedBox(width: 8),
                          Text('Kharcha Sheet (Wages & Deductions)'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'overtime',
                      child: Row(
                        children: [
                          Icon(Icons.more_time, color: Color(0xFFE65100), size: 18),
                          SizedBox(width: 8),
                          Text('Overtime Sheet (Days & Hours)'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      _sheetType = val;
                      final suffix = _sheetType == 'overtime' ? 'Overtime' : 'Kharcha';
                      _titleController.text = '${_cutoffDate.day} $suffix';
                    });
                  },
                ),
                const SizedBox(height: 14),

                // Sheet Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Sheet Title',
                    hintText: 'e.g. 22 Kharcha',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),

                // Category
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'e.g. Labour or Staff',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),

                // Company
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company / Project',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                // Supervisor / Cash Holder
                TextFormField(
                  controller: _operatorNameController,
                  decoration: const InputDecoration(
                    labelText: 'Supervisor / Cash Holder (Optional)',
                    hintText: 'Name of person handed cash to disburse',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                // Cash Amount Given
                TextFormField(
                  controller: _amountGivenController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Cash Amount Given (PKR)',
                    hintText: 'Total cash handed over to supervisor',
                    border: OutlineInputBorder(),
                    prefixText: '₨ ',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Active operators will automatically be populated with their default daily rates.',
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
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
            foregroundColor: AppColors.textWhite,
          ),
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Create Sheet'),
        ),
      ],
    );
  }
}
