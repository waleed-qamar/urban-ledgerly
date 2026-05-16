import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/inventory/presentation/providers/inventory_providers.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/procurement/domain/entities/procurement_entity.dart';
import 'package:ledgerly/features/procurement/presentation/providers/procurement_providers.dart';
import 'package:ledgerly/features/raw_material/presentation/providers/raw_material_providers.dart';
import 'package:ledgerly/features/vender/presentation/providers/vendor_providers.dart';

class AddProcurementDialog extends ConsumerStatefulWidget {
  const AddProcurementDialog({super.key});

  @override
  ConsumerState<AddProcurementDialog> createState() =>
      _AddProcurementDialogState();
}

class _AddProcurementDialogState extends ConsumerState<AddProcurementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();
  final _amountController = TextEditingController(text: '0.00');
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int? _selectedRawMaterialId;
  int? _selectedVendorId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_recalculateAmount);
    _rateController.addListener(_recalculateAmount);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _rateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _recalculateAmount() {
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final rate = double.tryParse(_rateController.text.trim()) ?? 0;
    final total = quantity * rate;
    _amountController.text = total.toStringAsFixed(2);
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
    if (!isValid ||
        _selectedRawMaterialId == null ||
        _selectedVendorId == null) {
      return;
    }

    setState(() => _isSaving = true);

    final quantity = int.parse(_quantityController.text.trim());
    final rate = double.parse(_rateController.text.trim());
    final total = quantity * rate;

    final procurement = ProcurementEntity(
      rawMaterialId: _selectedRawMaterialId!,
      vendorId: _selectedVendorId!,
      procurementDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
      quantity: quantity,
      price: rate,
      total: total,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    try {
      await ref
          .read(procurementRepositoryProvider)
          .createProcurement(procurement);

      // Await the refresh to ensure data is fetched before closing
      // This refreshes both procurement data and inventory transactions
      await ref.refresh(getAllProcurementsProvider);
      await ref.refresh(
        inventoryTransactionsForItemProvider(
          _selectedRawMaterialId!,
          'RAW_MATERIAL',
        ),
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save procurement: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialsAsync = ref.watch(getAllRawMaterialsProvider);
    final vendorsAsync = ref.watch(getAllvendorsProvider);
    final procurementsAsync = ref.watch(getAllProcurementsProvider);

    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      title: Row(
        children: [
          const Expanded(
            child: Text(
              'Add Material Procurement',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: procurementsAsync.when(
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
        width: 980,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  label: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                ),
                const SizedBox(height: 16),
                const Text('Raw Material *'),
                const SizedBox(height: 8),
                rawMaterialsAsync.when(
                  loading: () => const LinearProgressIndicator(minHeight: 2),
                  error: (error, _) => Text(
                    'Failed to load materials: $error',
                    style: const TextStyle(color: AppColors.errorText),
                  ),
                  data: (materials) {
                    return DropdownButtonFormField<int>(
                      initialValue: _selectedRawMaterialId,
                      decoration: const InputDecoration(
                        hintText: 'Select Material',
                        border: OutlineInputBorder(),
                      ),
                      items: materials
                          .map(
                            (material) => DropdownMenuItem<int>(
                              value: material.id,
                              child: Text(material.name),
                            ),
                          )
                          .toList(),
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              setState(() {
                                _selectedRawMaterialId = value;
                                final matches = materials
                                    .where((m) => m.id == value)
                                    .toList();
                                final selected = matches.isNotEmpty
                                    ? matches.first
                                    : null;
                                if (selected != null &&
                                    _rateController.text.trim().isEmpty) {
                                  _rateController.text = selected.price
                                      .toStringAsFixed(2);
                                }
                              });
                            },
                      validator: (value) =>
                          value == null ? 'Raw material is required' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text('Vendor *'),
                const SizedBox(height: 8),
                vendorsAsync.when(
                  loading: () => const LinearProgressIndicator(minHeight: 2),
                  error: (error, _) => Text(
                    'Failed to load vendors: $error',
                    style: const TextStyle(color: AppColors.errorText),
                  ),
                  data: (vendors) {
                    final activeVendors = vendors
                        .where((v) => v.isActive)
                        .toList();
                    return DropdownButtonFormField<int>(
                      initialValue: _selectedVendorId,
                      decoration: const InputDecoration(
                        hintText: 'Select Vendor',
                        border: OutlineInputBorder(),
                      ),
                      items: activeVendors
                          .map(
                            (vendor) => DropdownMenuItem<int>(
                              value: vendor.id,
                              child: Text(vendor.vendorName),
                            ),
                          )
                          .toList(),
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              setState(() {
                                _selectedVendorId = value;
                              });
                            },
                      validator: (value) =>
                          value == null ? 'Vendor is required' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        enabled: !_isSaving,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Quantity *',
                          hintText: 'Enter Quantity',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Quantity is required';
                          }
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _rateController,
                        enabled: !_isSaving,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Rate *',
                          hintText: 'Enter Rate',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Rate is required';
                          }
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid rate';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Auto Calculated',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  enabled: !_isSaving,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Remarks',
                    hintText: 'Remarks',
                    border: OutlineInputBorder(),
                  ),
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
