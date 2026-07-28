import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';
import 'package:ledgerly/core/widgets/searchable_dropdown.dart';

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
  late final TextEditingController _monthlySalaryController;
  late final TextEditingController _deviceEmployeeCodeController;
  final _hourlyRateControllers = <int, TextEditingController>{};

  late DateTime _joiningDate;
  late bool _isActive;
  late bool _overtimeEnabled;

  int? _workGroupId;
  int? _defaultWageRoleId;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final op = widget.clientToEdit;

    _nameController = TextEditingController(text: op?.name ?? '');
    _phoneController = TextEditingController(text: op?.phone ?? '');
    _cnicController = TextEditingController(text: op?.cnic ?? '');

    // Preload salary
    _monthlySalaryController = TextEditingController(
      text: op?.monthlySalary != null
          ? op!.monthlySalary!.toStringAsFixed(2)
          : '',
    );

    _deviceEmployeeCodeController = TextEditingController(text: op?.deviceEmployeeCode ?? '');

    _joiningDate = op?.joiningDate ?? DateTime.now();
    _isActive = op?.isActive ?? true;
    _workGroupId = op?.workGroupId;
    _defaultWageRoleId = op?.defaultWageRoleId;
    _overtimeEnabled = op?.overtimeEnabled ?? true;
  }

  TextEditingController _getRoleRateController(int roleId) {
    if (!_hourlyRateControllers.containsKey(roleId)) {
      _hourlyRateControllers[roleId] = TextEditingController(
        text: widget.clientToEdit?.hourlyRates[roleId]?.toStringAsFixed(2) ?? '',
      );
    }
    return _hourlyRateControllers[roleId]!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    _monthlySalaryController.dispose();
    _deviceEmployeeCodeController.dispose();
    for (final c in _hourlyRateControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final monthlySalary = _monthlySalaryController.text.trim().isEmpty
        ? null
        : double.tryParse(_monthlySalaryController.text.trim());

    final hourlyRates = <int, double>{};
    for (final entry in _hourlyRateControllers.entries) {
      final rateStr = entry.value.text.trim();
      if (rateStr.isNotEmpty) {
        final rate = double.tryParse(rateStr);
        if (rate != null) hourlyRates[entry.key] = rate;
      }
    }

    final operator = OperatorEntity(
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
      monthlySalary: monthlySalary,
      deviceEmployeeCode: _deviceEmployeeCodeController.text.trim().isEmpty 
          ? null 
          : _deviceEmployeeCodeController.text.trim(),
      hourlyRates: hourlyRates,
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
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Name ──────────────────────────────────────────────
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),

                // ── ZKTeco Device ID ──────────────────────────────────
                TextFormField(
                  controller: _deviceEmployeeCodeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'ZKTeco Device ID (Optional)',
                    border: OutlineInputBorder(),
                    helperText: 'Enter the ID assigned on the ZKTeco device to sync punches.',
                    helperMaxLines: 2,
                  ),
                ),
                const SizedBox(height: 14),

                // ── Phone ─────────────────────────────────────────────
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
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),

                // ── CNIC ──────────────────────────────────────────────
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

                // ── Joining Date ──────────────────────────────────────
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
                          lastDate: DateTime.now(),
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
                const SizedBox(height: 14),

                // ── Work Group + Default Role ──────────────────────────
                Row(
                  children: [
                    // Work Group dropdown
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final async = ref.watch(getAllWorkGroupsProvider);
                          return async.when(
                            data: (groups) {
                              final noneGroup = {'id': null, 'name': 'None'};
                              final items = <Map<String, dynamic>>[noneGroup, ...groups];
                              
                              final selectedGroup = _workGroupId != null
                                  ? groups.where((g) => g['id'] == _workGroupId).firstOrNull
                                  : null;
                              final initialTextStr = selectedGroup != null ? selectedGroup['name'] as String : 'None';
                              
                              return SearchableDropdown<Map<String, dynamic>>(
                                items: items,
                                displayStringForOption: (g) => g['name'] as String,
                                onSelected: (val) =>
                                    setState(() => _workGroupId = val['id'] as int?),
                                initialText: initialTextStr,
                                labelText: 'Work Group',
                              );
                            },
                            loading: () =>
                                const LinearProgressIndicator(),
                            error: (e, _) => Text('Error: $e'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Default Wage Role dropdown
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final async = ref.watch(getAllWageRolesProvider);
                          return async.when(
                            data: (roles) {
                              final noneRole = {'id': null, 'role_name': 'None'};
                              final items = <Map<String, dynamic>>[noneRole, ...roles];

                              final selectedRole = _defaultWageRoleId != null
                                  ? roles.where((r) => r['id'] == _defaultWageRoleId).firstOrNull
                                  : null;
                              final initialTextStr = selectedRole != null ? selectedRole['role_name'] as String : 'None';

                              return SearchableDropdown<Map<String, dynamic>>(
                                items: items,
                                displayStringForOption: (r) => r['role_name'] as String,
                                onSelected: (val) =>
                                    setState(() => _defaultWageRoleId = val['id'] as int?),
                                initialText: initialTextStr,
                                labelText: 'Default Role',
                              );
                            },
                            loading: () =>
                                const LinearProgressIndicator(),
                            error: (e, _) => Text('Error: $e'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Rate Section ──────────────────────────────────────
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Pay Rates',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),

                // Monthly Salary
                TextFormField(
                  controller: _monthlySalaryController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Monthly Salary (PKR)',
                    hintText: 'Leave blank for hourly workers',
                    border: OutlineInputBorder(),
                    prefixText: '₨ ',
                  ),
                ),
                const SizedBox(height: 14),

                // Hourly Rates per Role
                const Text(
                  'Hourly Rates (by Role)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Consumer(
                  builder: (context, ref, _) {
                    final rolesAsync = ref.watch(getAllWageRolesProvider);
                    return rolesAsync.when(
                      data: (roles) => Column(
                        children: roles.map((role) {
                          final roleId = role['id'] as int;
                          final roleName = role['role_name'] as String;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TextFormField(
                              controller: _getRoleRateController(roleId),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              ],
                              decoration: InputDecoration(
                                labelText: '$roleName Rate / Hr (PKR)',
                                hintText: 'Leave blank if not applicable',
                                border: const OutlineInputBorder(),
                                prefixText: '₨ ',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Error: $e'),
                    );
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hourly workers get paid based on the role assigned to their shift.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                const Divider(),

                // ── Toggles ────────────────────────────────────────────
                SwitchListTile(
                  title: const Text('Overtime Enabled'),
                  subtitle: const Text('Allow overtime calculation for this operator'),
                  value: _overtimeEnabled,
                  onChanged: (val) => setState(() => _overtimeEnabled = val),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
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
                  widget.clientToEdit != null
                      ? 'Update Record'
                      : 'Save Record',
                ),
        ),
      ],
    );
  }
}
