import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';

import '../../../../core/theme/app_colors.dart';
import '../provider/operator_providers.dart';

class AddEmployeeDialog extends ConsumerStatefulWidget {
  final dynamic clientToEdit;

  const AddEmployeeDialog({super.key, this.clientToEdit});

  @override
  ConsumerState<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends ConsumerState<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cnicController;
  late DateTime _joiningDate;
  late bool _isActive;
  int? _workGroupId;
  int? _defaultWageRoleId;
  late bool _overtimeEnabled;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.clientToEdit?.name ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.clientToEdit?.phone ?? '',
    );
    _cnicController = TextEditingController(
      text: widget.clientToEdit?.cnic ?? '',
    );
    _joiningDate = widget.clientToEdit?.joiningDate ?? DateTime.now();
    _isActive = widget.clientToEdit?.isActive ?? true;
    _workGroupId = widget.clientToEdit?.workGroupId;
    _defaultWageRoleId = widget.clientToEdit?.defaultWageRoleId;
    _overtimeEnabled = widget.clientToEdit?.overtimeEnabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final employee = OperatorEntity(
      id: widget.clientToEdit?.id ?? 0,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      cnic: _cnicController.text.trim().isEmpty
          ? null
          : _cnicController.text.trim(),
      joiningDate: _joiningDate,
      isActive: _isActive,
      createdAt: widget.clientToEdit?.createdAt ?? DateTime.now(),
      workGroupId: _workGroupId,
      defaultWageRoleId: _defaultWageRoleId,
      overtimeEnabled: _overtimeEnabled,
    );

    try {
      if (widget.clientToEdit != null) {
        await ref.read(operatorRepositoryProvider).updateEmployee(employee);
      } else {
        await ref.read(operatorRepositoryProvider).addEmployee(employee);
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
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cnicController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]-')),
                ],
                decoration: const InputDecoration(
                  labelText: 'CNIC (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Joining Date: ${_joiningDate.year.toString().padLeft(4, '0')}-${_joiningDate.month.toString().padLeft(2, '0')}-${_joiningDate.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _joiningDate,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _joiningDate = picked);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Select'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final workGroupsAsync = ref.watch(getAllWorkGroupsProvider);
                        return workGroupsAsync.when(
                          data: (groups) => DropdownButtonFormField<int>(
                            value: _workGroupId,
                            decoration: const InputDecoration(labelText: 'Work Group', border: OutlineInputBorder()),
                            items: [
                              const DropdownMenuItem<int>(value: null, child: Text('None')),
                              ...groups.map((g) => DropdownMenuItem<int>(
                                value: g['id'] as int,
                                child: Text(g['name'] as String),
                              )),
                            ],
                            onChanged: (val) => setState(() => _workGroupId = val),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (e, s) => Text('Err: $e'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final rolesAsync = ref.watch(getAllWageRolesProvider);
                        return rolesAsync.when(
                          data: (roles) => DropdownButtonFormField<int>(
                            value: _defaultWageRoleId,
                            decoration: const InputDecoration(labelText: 'Default Wage Role', border: OutlineInputBorder()),
                            items: [
                              const DropdownMenuItem<int>(value: null, child: Text('None')),
                              ...roles.map((r) => DropdownMenuItem<int>(
                                value: r['id'] as int,
                                child: Text(r['role_name'] as String),
                              )),
                            ],
                            onChanged: (val) => setState(() => _defaultWageRoleId = val),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (e, s) => Text('Err: $e'),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text('Overtime Enabled'),
                value: _overtimeEnabled,
                onChanged: (val) => setState(() => _overtimeEnabled = val),
                activeThumbColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: const Text('Is Active'),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
                activeThumbColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ],
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
