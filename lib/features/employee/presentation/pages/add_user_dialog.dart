import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/core/widgets/searchable_dropdown.dart';
import 'package:ledgerly/features/auth/presentation/provider/current_employee_provider.dart';
import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'package:ledgerly/features/employee/presentation/provider/operator_providers.dart';

class AddUserDialog extends ConsumerStatefulWidget {
  final EmployeeEntity? userToEdit;

  const AddUserDialog({super.key, this.userToEdit});

  @override
  ConsumerState<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends ConsumerState<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cnicController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late DateTime _joiningDate;
  late bool _isActive;
  int? _selectedRoleId;

  bool _isLoading = false;
  bool _obscurePassword = true;

  bool get _isEditing => widget.userToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userToEdit?.name ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.userToEdit?.phone ?? '',
    );
    _cnicController = TextEditingController(
      text: widget.userToEdit?.cnic ?? '',
    );
    _emailController = TextEditingController(
      text: widget.userToEdit?.email ?? '',
    );
    _passwordController = TextEditingController();
    _joiningDate = widget.userToEdit?.joiningDate ?? DateTime.now();
    _isActive = widget.userToEdit?.isActive ?? true;
    _selectedRoleId = widget.userToEdit?.roleId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        // --- EDIT: update the employee record only (no auth changes) ---
        final user = EmployeeEntity(
          id: widget.userToEdit!.id,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          cnic: _cnicController.text.trim().isEmpty
              ? null
              : _cnicController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          joiningDate: _joiningDate,
          isActive: _isActive,
          roleId: _selectedRoleId,
          userId: widget.userToEdit?.userId,
          createdAt: widget.userToEdit?.createdAt ?? DateTime.now(),
        );
        await ref.read(operatorRepositoryProvider).updateCompanyEmployee(user);
      } else {
        // --- CREATE: call Edge Function to create auth account + employee row ---
        await ref
            .read(operatorRepositoryProvider)
            .createEmployeeWithAccount(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              cnic: _cnicController.text.trim().isEmpty
                  ? null
                  : _cnicController.text.trim(),
              joiningDate: _joiningDate,
              isActive: _isActive,
              roleId: _selectedRoleId,
            );
      }

      ref.invalidate(getAllEmployeesProvider);
      ref.invalidate(currentEmployeeProvider);
      ref.invalidate(userPermissionsProvider);
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
    final rolesAsync = ref.watch(getAllRolesProvider);

    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: Text(_isEditing ? 'Edit Employee Record' : 'Add New Employee'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Full Name
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

                // Phone
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

                // CNIC (optional)
                TextFormField(
                  controller: _cnicController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'CNIC (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Email — required when creating, optional label when editing
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: _isEditing ? 'Email (Optional)' : 'Email',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (val) {
                    if (!_isEditing && (val == null || val.trim().isEmpty)) {
                      return 'Email is required to create a login account';
                    }
                    if (val != null && val.trim().isNotEmpty) {
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(val.trim())) {
                        return 'Enter a valid email address';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password — only shown when creating a new employee
                if (!_isEditing) ...[
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Password is required';
                      }
                      if (val.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Role dropdown
                rolesAsync.when(
                  data: (roles) {
                    if (_selectedRoleId == null && roles.isNotEmpty) {
                      // Schedule update after build
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && _selectedRoleId == null) {
                          setState(() => _selectedRoleId = roles.first['id'] as int);
                        }
                      });
                    }
                    final selectedRole = _selectedRoleId != null
                        ? roles.where((r) => r['id'] == _selectedRoleId).firstOrNull
                        : null;
                    final initialTextStr = selectedRole != null ? selectedRole['name'].toString().toUpperCase() : null;

                    return SearchableDropdown<Map<String, dynamic>>(
                      items: roles,
                      displayStringForOption: (r) => r['name'].toString().toUpperCase(),
                      onSelected: (val) => setState(() => _selectedRoleId = val['id'] as int),
                      initialText: initialTextStr,
                      labelText: 'Role',
                      errorText: _selectedRoleId == null ? 'Required' : null,
                    );
                  },
                  loading: () => const Align(
                    alignment: Alignment.centerLeft,
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Text('Error loading roles: $e'),
                ),
                const SizedBox(height: 16),

                // Joining Date
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
                        if (picked != null) {
                          setState(() => _joiningDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Select'),
                    ),
                  ],
                ),

                // Is Active toggle
                SwitchListTile(
                  title: const Text('Is Active'),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),

                // Hint shown only on create
                if (!_isEditing)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'A login account will be created with the email and password above.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
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
              : Text(_isEditing ? 'Update Record' : 'Create Account'),
        ),
      ],
    );
  }
}
