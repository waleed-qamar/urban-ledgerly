import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../provider/operator_providers.dart';

class AddEmployeeDialog extends ConsumerStatefulWidget {
  final OperatorEntity? clientToEdit;

  const AddEmployeeDialog({super.key, this.clientToEdit});

  @override
  ConsumerState<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends ConsumerState<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cnicController;
  late final TextEditingController _defaultPerDayController;

  late DateTime _joiningDate;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final op = widget.clientToEdit;

    _nameController = TextEditingController(text: op?.name ?? '');
    _phoneController = TextEditingController(text: op?.phone ?? '');
    _cnicController = TextEditingController(text: op?.cnic ?? '');
    _defaultPerDayController = TextEditingController(
      text: op != null && op.defaultPerDay > 0
          ? op.defaultPerDay.toStringAsFixed(0)
          : '',
    );

    _joiningDate = op?.joiningDate ?? DateTime.now();
    _isActive = op?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    _defaultPerDayController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final defaultPerDay = double.tryParse(_defaultPerDayController.text.trim()) ?? 0.0;

    final operator = OperatorEntity(
      id: widget.clientToEdit?.id ?? 0,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      cnic: _cnicController.text.trim().isEmpty
          ? null
          : _cnicController.text.trim(),
      joiningDate: _joiningDate,
      defaultPerDay: defaultPerDay,
      isActive: _isActive,
      createdAt: widget.clientToEdit?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.clientToEdit != null) {
        await ref.read(operatorRepositoryProvider).updateEmployee(operator);
      } else {
        await ref.read(operatorRepositoryProvider).addEmployee(operator);
      }
      ref.invalidate(getAllOperatorsProvider);
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
    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: Text(
        widget.clientToEdit != null ? 'Edit Employee' : 'Add New Employee',
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\-+]')),
                  ],
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),

                // CNIC
                TextFormField(
                  controller: _cnicController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'CNIC (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                // Default Daily Rate (Per Day)
                TextFormField(
                  controller: _defaultPerDayController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Default Daily Rate (PKR)',
                    hintText: 'e.g. 1600 or 1400',
                    border: OutlineInputBorder(),
                    prefixText: '₨ ',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return null;
                    if (double.tryParse(val.trim()) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Joining Date
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Joining: '
                        '${_joiningDate.year.toString().padLeft(4, '0')}-'
                        '${_joiningDate.month.toString().padLeft(2, '0')}-'
                        '${_joiningDate.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _joiningDate,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => _joiningDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: const Text('Select'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Active Switch
                SwitchListTile(
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
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
              : Text(
                  widget.clientToEdit != null ? 'Update Record' : 'Save Record',
                ),
        ),
      ],
    );
  }
}
