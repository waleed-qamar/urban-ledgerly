import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/products/domain/entities/product_set_entity.dart';
import 'package:ledgerly/features/products/domain/entities/product_set_item_entity.dart';
import 'package:ledgerly/features/products/presentation/providers/product_providers.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ledgerly/core/widgets/searchable_dropdown.dart';
import 'package:ledgerly/features/products/domain/entities/product_entity.dart';

class AddProductsetDialog extends ConsumerStatefulWidget {
  final ProductSetEntity? setToEdit;
  const AddProductsetDialog({super.key, this.setToEdit});

  @override
  ConsumerState<AddProductsetDialog> createState() =>
      _AddProductsetDialogState();
}

class _AddProductsetDialogState extends ConsumerState<AddProductsetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _isSubmitting = false;

  late final List<_DraftProduct> _draftProducts;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.setToEdit?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.setToEdit?.description ?? '',
    );
    if (widget.setToEdit != null && widget.setToEdit!.products.isNotEmpty) {
      _draftProducts = widget.setToEdit!.products.map((item) {
        final draft = _DraftProduct();
        draft.id = item.productId;
        return draft;
      }).toList();
    } else {
      _draftProducts = [_DraftProduct()];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(getAllProductsProvider);
    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(widget.setToEdit != null ? 'Edit Product Set' : 'Add Product Set'),

      content: SizedBox(
        width: 50.h,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Set Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a set name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                productAsync.when(
                  error: (err, _) => SizedBox(
                    height: 240,
                    child: Center(
                      child: Text(
                        'Unable to load Product: $err',
                        style: const TextStyle(color: AppColors.errorText),
                      ),
                    ),
                  ),
                  loading: () => const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  data: (products) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Add products to Set',
                                style: TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: _isSubmitting
                                    ? null
                                    : () {
                                        setState(() {
                                          _draftProducts.add(_DraftProduct());
                                        });
                                      },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Row'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(_draftProducts.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                    Expanded(
                                      child: Builder(
                                        builder: (context) {
                                          ProductEntity? currentSelected;
                                          try {
                                            if (_draftProducts[index].id != null) {
                                              currentSelected = products.firstWhere(
                                                (p) => p.id == _draftProducts[index].id,
                                              );
                                            }
                                          } catch (_) {}

                                          return SearchableDropdown<ProductEntity>(
                                            items: products,
                                            labelText: 'Product ${index + 1}',
                                            initialText: currentSelected?.name,
                                            enabled: !_isSubmitting,
                                            displayStringForOption: (product) => product.name,
                                            onSelected: (product) {
                                              setState(() {
                                                _draftProducts[index].id = product.id;
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  if (_draftProducts.length > 1)
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: _isSubmitting
                                          ? null
                                          : () {
                                              setState(() {
                                                _draftProducts.removeAt(index);
                                              });
                                            },
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton.icon(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }

                  final productIds = _draftProducts
                      .map((draftProduct) => draftProduct.id)
                      .whereType<int>()
                      .toList();

                  if (productIds.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add at least one product to the set.'),
                      ),
                    );
                    return;
                  }

                  if (productIds.toSet().length != productIds.length) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Each product can only appear once.'),
                      ),
                    );
                    return;
                  }

                  final productSet = ProductSetEntity(
                    setId: widget.setToEdit?.setId,
                    name: _nameController.text.trim(),
                    description: _descriptionController.text.trim().isEmpty
                        ? null
                        : _descriptionController.text.trim(),
                    products: productIds
                        .map(
                          (productId) =>
                              ProductSetItemEntity(productId: productId),
                        )
                        .toList(),
                  );

                  setState(() {
                    _isSubmitting = true;
                  });

                  try {
                    if (widget.setToEdit != null) {
                      await ref
                          .read(productRepositoryProvider)
                          .updateProductSet(productSet);
                    } else {
                      await ref
                          .read(addProductSetProvider(productSet).future);
                    }
                    ref.invalidate(getAllProductSetsProvider);
                    if (mounted) {
                      Navigator.of(context.mounted ? context : context).pop();
                      ScaffoldMessenger.of(
                        context.mounted ? context : context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.setToEdit != null
                                ? 'Product set updated successfully'
                                : 'Product set created successfully',
                          ),
                        ),
                      );
                    }
                  } catch (error) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context.mounted ? context : context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.setToEdit != null
                                ? 'Failed to update product set: $error'
                                : 'Failed to create product set: $error',
                          ),
                          backgroundColor: AppColors.errorText,
                        ),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isSubmitting = false;
                      });
                    }
                  }
                },
          icon: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(widget.setToEdit != null ? 'Save Changes' : 'Add Set'),
        ),
      ],
    );
  }
}

class _DraftProduct {
  int? id;
  _DraftProduct();
}
