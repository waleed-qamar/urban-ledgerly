import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/vendor_entity.dart';
import '../providers/vendor_providers.dart';

class AddVenderDialog extends ConsumerStatefulWidget {
  final VendorEntity? venderToEdit;

  const AddVenderDialog({super.key, this.venderToEdit});

  @override
  ConsumerState<AddVenderDialog> createState() => _AddVenderDialogState();
}

class _AddVenderDialogState extends ConsumerState<AddVenderDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _companyController;
  late final TextEditingController _contactController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;
  late bool _isActive;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.venderToEdit?.vendorName ?? '',
    );
    _companyController = TextEditingController(
      text: widget.venderToEdit?.companyName ?? '',
    );
    _contactController = TextEditingController(
      text: widget.venderToEdit?.contactNumber ?? '',
    );
    _addressController = TextEditingController(
      text: widget.venderToEdit?.vendorAddress ?? '',
    );
    _notesController = TextEditingController(
      text: widget.venderToEdit?.vendorNotes ?? '',
    );
    _isActive = widget.venderToEdit?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final vender = VendorEntity(
      id: widget.venderToEdit?.id ?? 0,
      vendorName: _nameController.text.trim(),
      companyName: _companyController.text.trim(),
      contactNumber: _contactController.text.trim(),
      vendorAddress: _addressController.text.trim(),
      vendorNotes: _notesController.text.trim(),
      createdAt: widget.venderToEdit?.createdAt ?? DateTime.now(),
      isActive: _isActive,
    );

    try {
      if (widget.venderToEdit != null) {
        await ref.read(vendorRepositoryProvider).updateVender(vender);
      } else {
        await ref.read(vendorRepositoryProvider).addVender(vender);
      }

      ref.invalidate(getAllvendorsProvider);
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
        widget.venderToEdit != null ? 'Edit Vendor' : 'Add New Vendor',
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Vendor Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number / Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Vendor Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Vendor Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Is Active'),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
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
                  widget.venderToEdit != null ? 'Update Record' : 'Save Record',
                ),
        ),
      ],
    );
  }
}
