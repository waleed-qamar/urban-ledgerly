import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';

import '../providers/product_providers.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  final ProductEntity? productToEdit;
  const AddProductDialog({super.key, this.productToEdit});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _descriptionController;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.productToEdit?.name ?? '',
    );
    _weightController = TextEditingController(
      text: widget.productToEdit?.weight.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.productToEdit?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final product = ProductEntity(
      id: widget.productToEdit?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      weight: double.parse(_weightController.text.trim()),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      createdAt: widget.productToEdit?.createdAt ?? DateTime.now(),
    );
    try {
      if (widget.productToEdit != null) {
        await ref.read(productRepositoryProvider).updateProduct(product);
      } else {
        await ref.read(productRepositoryProvider).addProduct(product);
      }

      ref.invalidate(getAllProductsProvider);
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
        widget.productToEdit != null ? 'Edit Product' : 'Add Product',
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
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  final weight = double.tryParse(value.trim());
                  if (weight == null || weight <= 0) {
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
          child: Text(widget.productToEdit != null ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
