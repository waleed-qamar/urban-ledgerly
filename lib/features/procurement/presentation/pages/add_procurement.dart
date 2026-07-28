import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/inventory/presentation/providers/inventory_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../raw_material/domain/entities/raw_material_entity.dart';
import '../../../raw_material/presentation/providers/raw_material_providers.dart';
import '../../../vender/domain/entities/vendor_entity.dart';
import '../../../vender/presentation/providers/vendor_providers.dart';
import '../../domain/entities/procurement_entity.dart';
import '../../domain/entities/procurement_item_entity.dart';
import '../providers/procurement_providers.dart';
import '../../../../features/expense/domain/entities/expense_head.dart';
import '../../../../features/expense/presentation/providers/expense_providers.dart';

class _DraftProcurementLine {
  int? rawMaterialId;
  int quantity;
  double price;

  _DraftProcurementLine({
    this.rawMaterialId,
    required this.quantity,
    required this.price,
  });

  double get total => quantity * price;
}

class AddProcurementDialog extends ConsumerStatefulWidget {
  final ProcurementEntity? procurementToEdit;
  const AddProcurementDialog({super.key, this.procurementToEdit});

  @override
  ConsumerState<AddProcurementDialog> createState() =>
      _AddProcurementDialogState();
}

class _AddProcurementDialogState extends ConsumerState<AddProcurementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int? _selectedVendorId;
  int? _selectedBrokerId;
  final _brokerageController = TextEditingController(text: '0');
  final _loadingController = TextEditingController(text: '0');
  final _unloadingController = TextEditingController(text: '0');
  final _rentController = TextEditingController(text: '0');
  int? _selectedRentExpenseHeadId;

  bool _isSaving = false;

  final List<_DraftProcurementLine> _lines = [
    _DraftProcurementLine(quantity: 1, price: 0),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.procurementToEdit != null) {
      final p = widget.procurementToEdit!;
      _selectedDate = DateTime.tryParse(p.procurementDate) ?? DateTime.now();
      _selectedVendorId = p.vendorId;
      _selectedBrokerId = p.brokerId;
      _notesController.text = p.notes ?? '';
      _brokerageController.text = p.brokeragePrice.toStringAsFixed(2);
      _loadingController.text = p.loadingCharges.toStringAsFixed(2);
      _unloadingController.text = p.unloadingCharges.toStringAsFixed(2);
      _rentController.text = p.rentAmount.toStringAsFixed(2);
      _selectedRentExpenseHeadId = p.rentExpenseHeadId;
      
      _lines.clear();
      for (final item in p.items) {
        _lines.add(
          _DraftProcurementLine(
            rawMaterialId: item.rawMaterialId,
            quantity: item.quantity,
            price: item.price,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _brokerageController.dispose();
    _loadingController.dispose();
    _unloadingController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  double _calculateItemsTotal() {
    return _lines.fold<double>(0, (sum, line) => sum + line.total);
  }

  double _calculateGrandTotal() {
    final itemsTotal = _calculateItemsTotal();
    final brokerage = double.tryParse(_brokerageController.text) ?? 0;
    final loading = double.tryParse(_loadingController.text) ?? 0;
    final unloading = double.tryParse(_unloadingController.text) ?? 0;
    return itemsTotal + brokerage + loading + unloading;
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
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _selectedVendorId == null) {
      _showError('Please verify all fields are filled.');
      return;
    }

    final items = <ProcurementItemEntity>[];
    for (final line in _lines) {
      if (line.rawMaterialId == null) {
        _showError('Please select a raw material for all lines.');
        return;
      }
      if (line.quantity <= 0) {
        _showError('Quantity must be greater than 0.');
        return;
      }
      if (line.price <= 0) {
        _showError('Rate must be greater than 0.');
        return;
      }
      items.add(
        ProcurementItemEntity(
          rawMaterialId: line.rawMaterialId!,
          quantity: line.quantity,
          price: line.price,
          total: line.total,
        ),
      );
    }

    setState(() => _isSaving = true);

    final itemsTotal = _calculateItemsTotal();
    final grandTotal = _calculateGrandTotal();
    final brokerage = double.tryParse(_brokerageController.text) ?? 0;
    final loading = double.tryParse(_loadingController.text) ?? 0;
    final unloading = double.tryParse(_unloadingController.text) ?? 0;
    final rentAmount = double.tryParse(_rentController.text) ?? 0;

    final procurement = ProcurementEntity(
      id: widget.procurementToEdit?.id,
      vendorId: _selectedVendorId!,
      procurementDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
      brokerId: _selectedBrokerId,
      brokeragePrice: brokerage,
      loadingCharges: loading,
      unloadingCharges: unloading,
      rentAmount: rentAmount,
      rentExpenseHeadId: _selectedRentExpenseHeadId,
      itemsTotal: itemsTotal,
      total: grandTotal,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      items: items,
    );

    try {
      if (widget.procurementToEdit != null) {
        await ref
            .read(procurementRepositoryProvider)
            .updateProcurement(procurement);
      } else {
        await ref
            .read(procurementRepositoryProvider)
            .createProcurement(procurement);
      }

      // Refresh providers
      ref.invalidate(getAllProcurementsProvider);
      for (final item in items) {
        ref.invalidate(
          inventoryTransactionsForItemProvider(
            item.rawMaterialId,
            'RAW_MATERIAL',
          ),
        );
      }

      if (widget.procurementToEdit != null) {
        for (final oldItem in widget.procurementToEdit!.items) {
          ref.invalidate(
            inventoryTransactionsForItemProvider(
              oldItem.rawMaterialId,
              'RAW_MATERIAL',
            ),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        _showError('Failed to save procurement: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.errorText),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialsAsync = ref.watch(getAllRawMaterialsProvider);
    final vendorsAsync = ref.watch(getAllvendorsProvider);
    final procurementsAsync = ref.watch(getAllProcurementsProvider);
    final expenseHeadsAsync = ref.watch(expenseHeadsProvider);

    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.procurementToEdit != null
                  ? 'Edit Material Procurement'
                  : 'Add Material Procurement',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget.procurementToEdit != null
                ? Text(
                    'Procurement# ${widget.procurementToEdit!.id}',
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : procurementsAsync.when(
                    loading: () => const Text(
                      'Procurement# ...',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    error: (_, _) => const Text(
                      'Procurement# N/A',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    data: (procurements) {
                      final maxId = procurements
                          .map((p) => p.id ?? 0)
                          .fold<int>(0, (max, id) => id > max ? id : max);
                      final nextId = maxId + 1;

                      return Text(
                        'Procurement# $nextId',
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      content: SizedBox(
        width: 820,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isSaving ? null : _pickDate,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(
                        DateFormat('yyyy-MM-dd').format(_selectedDate),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: vendorsAsync.when(
                        loading: () =>
                            const LinearProgressIndicator(minHeight: 2),
                        error: (error, _) => Text(
                          'Failed to load vendors: $error',
                          style: const TextStyle(color: AppColors.errorText),
                        ),
                        data: (vendors) {
                          final activeVendors = vendors
                              .where((v) => v.isActive)
                              .toList();

                          return FormField<int>(
                            initialValue: _selectedVendorId,
                            validator: (value) =>
                                value == null ? 'Vendor is required' : null,
                            builder: (fieldState) {
                              final selectedVendor = activeVendors
                                  .where((v) => v.id == _selectedVendorId)
                                  .firstOrNull;

                              return SearchableDropdown<VendorEntity>(
                                items: activeVendors,
                                displayStringForOption: (v) => v.vendorName,
                                labelText: 'Vendor *',
                                errorText: fieldState.errorText,
                                enabled: !_isSaving,
                                initialText: selectedVendor?.vendorName,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedVendorId = selected.id;
                                  });
                                  fieldState.didChange(selected.id);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: vendorsAsync.when(
                        loading: () =>
                            const LinearProgressIndicator(minHeight: 2),
                        error: (error, _) => Text(
                          'Failed to load brokers: $error',
                          style: const TextStyle(color: AppColors.errorText),
                        ),
                        data: (vendors) {
                          final activeVendors = vendors
                              .where((v) => v.isActive)
                              .toList();

                          return FormField<int>(
                            initialValue: _selectedBrokerId,
                            builder: (fieldState) {
                              final selectedBroker = activeVendors
                                  .where((v) => v.id == _selectedBrokerId)
                                  .firstOrNull;

                              return SearchableDropdown<VendorEntity>(
                                items: activeVendors,
                                displayStringForOption: (v) => v.vendorName,
                                labelText: 'Broker (Optional)',
                                errorText: fieldState.errorText,
                                enabled: !_isSaving,
                                initialText: selectedBroker?.vendorName,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedBrokerId = selected.id;
                                  });
                                  fieldState.didChange(selected.id);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _brokerageController,
                        enabled: !_isSaving && _selectedBrokerId != null,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Brokerage Price',
                          border: OutlineInputBorder(),
                          prefixText: 'Rs. ',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Material Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _isSaving
                          ? null
                          : () {
                              setState(() {
                                _lines.add(
                                  _DraftProcurementLine(quantity: 1, price: 0),
                                );
                              });
                            },
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Add Material'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                rawMaterialsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text(
                    'Failed to load raw materials: $error',
                    style: const TextStyle(color: AppColors.errorText),
                  ),
                  data: (materials) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _lines.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _ProcurementLineEditor(
                          line: _lines[index],
                          materials: materials,
                          enabled: !_isSaving,
                          onChanged: () => setState(() {}),
                          onDelete: _lines.length == 1
                              ? null
                              : () {
                                  setState(() {
                                    _lines.removeAt(index);
                                  });
                                },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _loadingController,
                                  enabled: !_isSaving,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Loading Charges',
                                    border: OutlineInputBorder(),
                                    prefixText: 'Rs. ',
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _unloadingController,
                                  enabled: !_isSaving,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Unloading Charges',
                                    border: OutlineInputBorder(),
                                    prefixText: 'Rs. ',
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: expenseHeadsAsync.when(
                                  loading: () => const LinearProgressIndicator(minHeight: 2),
                                  error: (error, _) => Text(
                                    'Failed to load expense heads: $error',
                                    style: const TextStyle(color: AppColors.errorText),
                                  ),
                                  data: (heads) {
                                    // Auto-select first 'rent' head if none selected and there is a 'rent' head
                                    if (_selectedRentExpenseHeadId == null && widget.procurementToEdit == null) {
                                      final rentHead = heads.where((h) => h.name.toLowerCase().contains('rent')).firstOrNull;
                                      if (rentHead != null) {
                                        // Update state safely after build
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (mounted && _selectedRentExpenseHeadId == null) {
                                            setState(() {
                                              _selectedRentExpenseHeadId = rentHead.id;
                                            });
                                          }
                                        });
                                      }
                                    }

                                    return FormField<int>(
                                      initialValue: _selectedRentExpenseHeadId,
                                      builder: (fieldState) {
                                        final selectedHead = heads
                                            .where((h) => h.id == _selectedRentExpenseHeadId)
                                            .firstOrNull;

                                        return SearchableDropdown<ExpenseHead>(
                                          items: heads,
                                          displayStringForOption: (h) => h.name,
                                          labelText: 'Rent Expense Head (Optional)',
                                          errorText: fieldState.errorText,
                                          enabled: !_isSaving,
                                          initialText: selectedHead?.name,
                                          onSelected: (selected) {
                                            setState(() {
                                              _selectedRentExpenseHeadId = selected.id;
                                            });
                                            fieldState.didChange(selected.id);
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _rentController,
                                  enabled: !_isSaving,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Rent Amount',
                                    border: OutlineInputBorder(),
                                    prefixText: 'Rs. ',
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _notesController,
                            enabled: !_isSaving,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Remarks / Notes',
                              hintText: 'Add remarks...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.dividerColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'ITEMS TOTAL',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGrey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rs. ${NumberFormat('#,##0.00').format(_calculateItemsTotal())}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'GRAND TOTAL',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGrey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rs. ${NumberFormat('#,##0.00').format(_calculateGrandTotal())}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        SizedBox(
          width: 220,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF58A3A),
              foregroundColor: AppColors.textWhite,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textWhite,
                    ),
                  )
                : const Text('Save'),
          ),
        ),
      ],
    );
  }
}

class _ProcurementLineEditor extends StatefulWidget {
  final _DraftProcurementLine line;
  final List<RawMaterialEntity> materials;
  final bool enabled;
  final VoidCallback onChanged;
  final VoidCallback? onDelete;

  const _ProcurementLineEditor({
    required this.line,
    required this.materials,
    required this.enabled,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ProcurementLineEditor> createState() => _ProcurementLineEditorState();
}

class _ProcurementLineEditorState extends State<_ProcurementLineEditor> {
  // Controller to pre-fill the field when a material is already selected
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final preSelected = widget.line.rawMaterialId != null
        ? widget.materials
              .where((m) => m.id == widget.line.rawMaterialId)
              .map((m) => m.name)
              .firstOrNull
        : null;
    _searchController = TextEditingController(text: preSelected ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: FormField<int>(
              initialValue: widget.line.rawMaterialId,
              validator: (value) => value == null ? 'Select material' : null,
              builder: (fieldState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchableDropdown<RawMaterialEntity>(
                      items: widget.materials,
                      displayStringForOption: (m) => m.name,
                      labelText: 'Select Material',
                      errorText: fieldState.errorText,
                      enabled: widget.enabled,
                      onSelected: (selected) {
                        widget.line.rawMaterialId = selected.id;
                        widget.line.price = selected.price;
                        fieldState.didChange(selected.id);
                        widget.onChanged();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: TextFormField(
              initialValue: widget.line.quantity > 0
                  ? widget.line.quantity.toString()
                  : '',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Qty',
              ),
              enabled: widget.enabled,
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Invalid';
                }
                return null;
              },
              onChanged: (value) {
                widget.line.quantity = int.tryParse(value) ?? 0;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 140,
            child: TextFormField(
              key: ValueKey('price_${widget.line.rawMaterialId}'),
              initialValue: widget.line.price > 0
                  ? widget.line.price.toStringAsFixed(2)
                  : '',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Rate',
                prefixText: 'Rs. ',
              ),
              enabled: widget.enabled,
              validator: (value) {
                final parsed = double.tryParse((value ?? '').trim());
                if (parsed == null || parsed <= 0) {
                  return 'Invalid';
                }
                return null;
              },
              onChanged: (value) {
                widget.line.price = double.tryParse(value) ?? 0;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 140,
            child: TextFormField(
              key: ValueKey(widget.line.total),
              initialValue: widget.line.total > 0
                  ? widget.line.total.toStringAsFixed(2)
                  : '0.00',
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
                prefixText: 'Rs. ',
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: widget.enabled ? widget.onDelete : null,
            icon: const Icon(Icons.delete_outline, color: AppColors.errorText),
          ),
        ],
      ),
    );
  }
}
