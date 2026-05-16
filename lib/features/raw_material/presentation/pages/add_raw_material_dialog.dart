import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/raw_material/domain/entities/raw_material_entity.dart';

import '../providers/raw_material_providers.dart';

class AddRawMaterialDialog extends ConsumerStatefulWidget {
  final RawMaterialEntity? materialToEdit;
  const AddRawMaterialDialog({super.key, this.materialToEdit});

  @override
  ConsumerState<AddRawMaterialDialog> createState() =>
      _AddRawMaterialDialogState();
}

class _AddRawMaterialDialogState extends ConsumerState<AddRawMaterialDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.materialToEdit?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.materialToEdit?.price.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.materialToEdit?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final material = RawMaterialEntity(
      id: widget.materialToEdit?.id ?? 0,
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      createdAt: widget.materialToEdit?.createdAt ?? DateTime.now(),
    );
    try {
      if (widget.materialToEdit != null) {
        await ref
            .read(rawMaterialRepositoryProvider)
            .updateRawMaterial(material);
      } else {
        await ref.read(rawMaterialRepositoryProvider).addRawMaterial(material);
      }

      ref.invalidate(getAllRawMaterialsProvider);
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
        widget.materialToEdit != null
            ? 'Edit Raw Material'
            : 'Add Raw Material',
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
                decoration: const InputDecoration(labelText: 'Material Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Average Price',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  final price = double.tryParse(value.trim());
                  if (price == null || price <= 0) {
                    return 'Enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
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
          onPressed: _isLoading ? null : _submit,
          child: Text(widget.materialToEdit != null ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
