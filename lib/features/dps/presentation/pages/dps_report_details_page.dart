import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';

import '../../domain/entities/dps_models.dart';
import '../providers/dps_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../raw_material/presentation/providers/raw_material_providers.dart';

final dpsReportDetailsProvider =
    FutureProvider.family<_DpsReportDetailsData, int>((ref, reportId) async {
      final repository = ref.watch(dpsRepositoryProvider);

      final productionLogs = await repository.getProductionLogsForReport(
        reportId,
      );
      final consumptionLogs = await repository.getConsumptionLogsForReport(
        reportId,
      );
      final damageLogs = await repository.getDamageLogsForReport(reportId);

      return _DpsReportDetailsData(
        productionLogs: productionLogs,
        consumptionLogs: consumptionLogs,
        damageLogs: damageLogs,
      );
    });

/// Shows report details (and, optionally, lets the user edit them) in a
/// constrained modal dialog instead of a full page. Returns `true` via
/// [Navigator.pop] if the report was changed, so the caller can refresh
/// its list.
class DpsReportDetailsDialog extends ConsumerStatefulWidget {
  final DpsReport report;

  const DpsReportDetailsDialog({super.key, required this.report});

  static Future<bool?> show(BuildContext context, DpsReport report) {
    return showDialog<bool>(
      context: context,
      builder: (_) => DpsReportDetailsDialog(report: report),
    );
  }

  @override
  ConsumerState<DpsReportDetailsDialog> createState() =>
      _DpsReportDetailsDialogState();
}

class _DpsReportDetailsDialogState
    extends ConsumerState<DpsReportDetailsDialog> {
  bool _isEditing = false;
  bool _isSaving = false;
  String? _saveError;

  late DateTime _editableDate;
  late TextEditingController _notesController;

  List<DpsProductionLog>? _editableProduction;
  List<DpsConsumptionLog>? _editableConsumption;
  List<DpsDamageLog>? _editableDamage;

  @override
  void initState() {
    super.initState();
    _editableDate = widget.report.reportDate;
    _notesController = TextEditingController(text: widget.report.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _enterEditMode(_DpsReportDetailsData details) {
    setState(() {
      _isEditing = true;
      _saveError = null;
      _editableProduction = [...details.productionLogs];
      _editableConsumption = [...details.consumptionLogs];
      _editableDamage = [...details.damageLogs];
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _saveError = null;
      _editableProduction = null;
      _editableConsumption = null;
      _editableDamage = null;
      _editableDate = widget.report.reportDate;
      _notesController.text = widget.report.notes ?? '';
    });
  }

  Future<void> _saveChanges(int reportId) async {
    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      final repository = ref.read(dpsRepositoryProvider);
      await repository.updateReport(
        reportId: reportId,
        reportDate: _editableDate,
        notes: _notesController.text,
        productionLogs: _editableProduction ?? [],
        consumptionLogs: _editableConsumption ?? [],
        damageLogs: _editableDamage ?? [],
      );

      ref.invalidate(dpsReportDetailsProvider(reportId));
      ref.invalidate(dpsReportsProvider);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _saveError = 'Failed to save changes: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportId = widget.report.id;
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width < 700
        ? screenSize.width * 0.94
        : 640.0;
    final dialogHeight = screenSize.height * 0.85 > 720
        ? 720.0
        : screenSize.height * 0.85;

    if (reportId == null) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: dialogWidth,
          padding: const EdgeInsets.all(24),
          child: Text(
            'Invalid report id',
            style: TextStyle(color: AppColors.errorText),
          ),
        ),
      );
    }

    final detailsAsync = ref.watch(dpsReportDetailsProvider(reportId));
    final machinesAsync = ref.watch(dpsMachinesProvider);
    final productsAsync = ref.watch(getAllProductsProvider);
    final rawMaterialsAsync = ref.watch(getAllRawMaterialsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          children: [
            _buildHeader(reportId),
            Divider(height: 1, color: AppColors.dividerColor),
            Expanded(
              child: detailsAsync.when(
                data: (details) => machinesAsync.when(
                  data: (machines) => productsAsync.when(
                    data: (products) => rawMaterialsAsync.when(
                      data: (materials) => _buildBody(
                        reportId,
                        details,
                        machines,
                        products,
                        materials,
                      ),
                      loading: () => _loadingIndicator(),
                      error: (e, _) => _errorText(e),
                    ),
                    loading: () => _loadingIndicator(),
                    error: (e, _) => _errorText(e),
                  ),
                  loading: () => _loadingIndicator(),
                  error: (e, _) => _errorText(e),
                ),
                loading: () => _loadingIndicator(),
                error: (e, _) => _errorText(e),
              ),
            ),
            if (_saveError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Text(
                  _saveError!,
                  style: TextStyle(color: AppColors.errorText),
                ),
              ),
            _buildFooter(reportId),
          ],
        ),
      ),
    );
  }

  Widget _loadingIndicator() =>
      Center(child: CircularProgressIndicator(color: AppColors.primary));

  Widget _errorText(Object e) => Center(
    child: Text('Error: $e', style: TextStyle(color: AppColors.errorText)),
  );

  Widget _buildHeader(int reportId) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          Icon(Icons.description_outlined, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isEditing ? 'Edit Report' : 'Report Details',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
          if (!_isEditing)
            TextButton.icon(
              onPressed: () {
                final details = ref
                    .read(dpsReportDetailsProvider(reportId))
                    .value;
                if (details != null) _enterEditMode(details);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit'),
            ),
          IconButton(
            icon: Icon(Icons.close, color: AppColors.textGrey),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(int reportId) {
    if (!_isEditing) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textBlack87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Close'),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isSaving ? null : _cancelEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textBlack87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: _isSaving ? null : () => _saveChanges(reportId),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(
                  alpha: 0.5,
                ),
                foregroundColor: AppColors.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isSaving
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textWhite,
                        ),
                      ),
                    )
                  : const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    int reportId,
    _DpsReportDetailsData details,
    List<Machine> machines,
    List<dynamic> products,
    List<dynamic> materials,
  ) {
    final productNames = {for (final p in products) p.id as int: p.name as String};
    final materialNames = {for (final m in materials) m.id as int: m.name as String};

    final sortedMachines = [...machines]..sort((a, b) => a.id.compareTo(b.id));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      children: [
        _buildMetaSection(),
        const SizedBox(height: 8),
        Divider(color: AppColors.dividerColor),

        const _SectionHeader(title: 'Production'),
        ...sortedMachines.map(
          (machine) => _ProductionCard(
            machine: machine,
            logs: _isEditing
                ? (_editableProduction ?? const [])
                      .where((l) => l.machineId == machine.id)
                      .toList()
                : details.productionByMachine[machine.id] ?? const [],
            productNames: productNames,
            products: products,
            isEditing: _isEditing,
            onAdd: !_isEditing
                ? null
                : () {
                    if (products.isEmpty) return;
                    setState(() {
                      _editableProduction!.add(
                        DpsProductionLog(
                          machineId: machine.id,
                          productId: products.first.id,
                          quantity: 1.0,
                        ),
                      );
                    });
                  },
            onUpdate: !_isEditing
                ? null
                : (log, updated) {
                    setState(() {
                      final i = _editableProduction!.indexOf(log);
                      if (i != -1) _editableProduction![i] = updated;
                    });
                  },
            onRemove: !_isEditing
                ? null
                : (log) => setState(() => _editableProduction!.remove(log)),
          ),
        ),

        Divider(color: AppColors.dividerColor),
        const _SectionHeader(title: 'Raw Material Consumption'),
        _ConsumptionCard(
          logs: _isEditing
              ? (_editableConsumption ?? const [])
              : details.consumptionLogs,
          materialNames: materialNames,
          materials: materials,
          isEditing: _isEditing,
          onAdd: !_isEditing
              ? null
              : () {
                  if (materials.isEmpty) return;
                  setState(() {
                    _editableConsumption!.add(
                      DpsConsumptionLog(
                        rawMaterialId: materials.first.id,
                        quantity: 1.0,
                      ),
                    );
                  });
                },
          onUpdate: !_isEditing
              ? null
              : (log, updated) {
                  setState(() {
                    final i = _editableConsumption!.indexOf(log);
                    if (i != -1) _editableConsumption![i] = updated;
                  });
                },
          onRemove: !_isEditing
              ? null
              : (log) => setState(() => _editableConsumption!.remove(log)),
        ),

        Divider(color: AppColors.dividerColor),
        const _SectionHeader(title: 'Damage'),
        ...sortedMachines.map(
          (machine) => _DamageCard(
            machine: machine,
            logs: _isEditing
                ? (_editableDamage ?? const [])
                      .where((l) => l.machineId == machine.id)
                      .toList()
                : details.damageByMachine[machine.id] ?? const [],
            productNames: productNames,
            materialNames: materialNames,
            products: products,
            isEditing: _isEditing,
            onAdd: !_isEditing
                ? null
                : () {
                    if (products.isEmpty) return;
                    setState(() {
                      _editableDamage!.add(
                        DpsDamageLog(
                          machineId: machine.id,
                          itemType: 'product',
                          itemId: products.first.id,
                          quantity: 1.0,
                        ),
                      );
                    });
                  },
            onUpdate: !_isEditing
                ? null
                : (log, updated) {
                    setState(() {
                      final i = _editableDamage!.indexOf(log);
                      if (i != -1) _editableDamage![i] = updated;
                    });
                  },
            onRemove: !_isEditing
                ? null
                : (log) => setState(() => _editableDamage!.remove(log)),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaSection() {
    if (!_isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaRow(
            icon: Icons.calendar_today_outlined,
            label: 'Report Date',
            value: DateFormat('yyyy-MM-dd').format(widget.report.reportDate),
          ),
          if (widget.report.notes != null &&
              widget.report.notes!.trim().isNotEmpty)
            _MetaRow(
              icon: Icons.notes_rounded,
              label: 'Notes',
              value: widget.report.notes!.trim(),
            ),
          _MetaRow(
            icon: Icons.flag_outlined,
            label: 'Status',
            value: widget.report.status,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _editableDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) setState(() => _editableDate = picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Report Date',
              suffixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
              border: const OutlineInputBorder(),
            ),
            child: Text(DateFormat('yyyy-MM-dd').format(_editableDate)),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DpsReportDetailsData {
  final List<DpsProductionLog> productionLogs;
  final List<DpsConsumptionLog> consumptionLogs;
  final List<DpsDamageLog> damageLogs;

  const _DpsReportDetailsData({
    required this.productionLogs,
    required this.consumptionLogs,
    required this.damageLogs,
  });

  Map<int, List<DpsProductionLog>> get productionByMachine {
    final grouped = <int, List<DpsProductionLog>>{};
    for (final log in productionLogs) {
      grouped.putIfAbsent(log.machineId, () => []).add(log);
    }
    return grouped;
  }

  Map<int, List<DpsDamageLog>> get damageByMachine {
    final grouped = <int, List<DpsDamageLog>>{};
    for (final log in damageLogs) {
      grouped.putIfAbsent(log.machineId, () => []).add(log);
    }
    return grouped;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textBlack87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Production

class _ProductionCard extends StatelessWidget {
  final Machine machine;
  final List<DpsProductionLog> logs;
  final Map<int, String> productNames;
  final List<dynamic> products;
  final bool isEditing;
  final VoidCallback? onAdd;
  final void Function(DpsProductionLog original, DpsProductionLog updated)?
  onUpdate;
  final void Function(DpsProductionLog log)? onRemove;

  const _ProductionCard({
    required this.machine,
    required this.logs,
    required this.productNames,
    required this.products,
    required this.isEditing,
    this.onAdd,
    this.onUpdate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: AppColors.textWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  machine.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.successText,
                  ),
                ),
                if (isEditing)
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.successText,
                      size: 20,
                    ),
                    onPressed: onAdd,
                  ),
              ],
            ),
            if (logs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'No production entries',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              )
            else
              ...logs.map((log) {
                if (!isEditing) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            productNames[log.productId] ?? 'Unknown Product',
                          ),
                        ),
                        Text(
                          log.quantity.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<int>(
                          initialValue: log.productId,
                          decoration: const InputDecoration(
                            labelText: 'Product',
                            isDense: true,
                          ),
                          items: products
                              .map(
                                (p) => DropdownMenuItem<int>(
                                  value: p.id as int,
                                  child: Text(p.name as String),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              onUpdate?.call(log, log.copyWith(productId: val));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: log.quantity.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Qty',
                            isDense: true,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 0.0;
                            onUpdate?.call(log, log.copyWith(quantity: parsed));
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.errorText,
                        ),
                        onPressed: () => onRemove?.call(log),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Consumption

class _ConsumptionCard extends StatelessWidget {
  final List<DpsConsumptionLog> logs;
  final Map<int, String> materialNames;
  final List<dynamic> materials;
  final bool isEditing;
  final VoidCallback? onAdd;
  final void Function(DpsConsumptionLog original, DpsConsumptionLog updated)?
  onUpdate;
  final void Function(DpsConsumptionLog log)? onRemove;

  const _ConsumptionCard({
    required this.logs,
    required this.materialNames,
    required this.materials,
    required this.isEditing,
    this.onAdd,
    this.onUpdate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: AppColors.textWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isEditing)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Raw Material'),
                ),
              ),
            if (logs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'No consumption entries',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              )
            else
              ...logs.map((log) {
                if (!isEditing) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            materialNames[log.rawMaterialId] ??
                                'Unknown Raw Material',
                          ),
                        ),
                        Text(
                          log.quantity.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<int>(
                          initialValue: log.rawMaterialId,
                          decoration: const InputDecoration(
                            labelText: 'Raw Material',
                            isDense: true,
                          ),
                          items: materials
                              .map(
                                (m) => DropdownMenuItem<int>(
                                  value: m.id as int,
                                  child: Text('${m.name} (${m.unit})'),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              onUpdate?.call(
                                log,
                                log.copyWith(rawMaterialId: val),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: log.quantity.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Qty',
                            isDense: true,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 0.0;
                            onUpdate?.call(log, log.copyWith(quantity: parsed));
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.errorText,
                        ),
                        onPressed: () => onRemove?.call(log),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Damage

class _DamageCard extends StatelessWidget {
  final Machine machine;
  final List<DpsDamageLog> logs;
  final Map<int, String> productNames;
  final Map<int, String> materialNames;
  final List<dynamic> products;
  final bool isEditing;
  final VoidCallback? onAdd;
  final void Function(DpsDamageLog original, DpsDamageLog updated)? onUpdate;
  final void Function(DpsDamageLog log)? onRemove;

  const _DamageCard({
    required this.machine,
    required this.logs,
    required this.productNames,
    required this.materialNames,
    required this.products,
    required this.isEditing,
    this.onAdd,
    this.onUpdate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: AppColors.textWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  machine.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorText,
                  ),
                ),
                if (isEditing)
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.errorText,
                      size: 20,
                    ),
                    onPressed: onAdd,
                  ),
              ],
            ),
            if (logs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'No damage entries',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              )
            else
              ...logs.map((log) {
                final itemName = log.itemType == 'product'
                    ? (productNames[log.itemId] ?? 'Unknown Product')
                    : (materialNames[log.itemId] ?? 'Unknown Raw Material');

                if (!isEditing) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 2, child: Text(itemName)),
                            Text(
                              log.quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (log.reason != null && log.reason!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              log.reason!,
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        Divider(color: AppColors.dividerColor),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<int>(
                              initialValue: log.itemId,
                              decoration: const InputDecoration(
                                labelText: 'Damaged Product',
                                isDense: true,
                              ),
                              items: products
                                  .map(
                                    (p) => DropdownMenuItem<int>(
                                      value: p.id as int,
                                      child: Text(p.name as String),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  onUpdate?.call(
                                    log,
                                    log.copyWith(itemId: val),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: log.quantity.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Qty',
                                isDense: true,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                              onChanged: (val) {
                                final parsed = double.tryParse(val) ?? 0.0;
                                onUpdate?.call(
                                  log,
                                  log.copyWith(quantity: parsed),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: AppColors.errorText,
                            ),
                            onPressed: () => onRemove?.call(log),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        initialValue: log.reason,
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          isDense: true,
                        ),
                        onChanged: (val) =>
                            onUpdate?.call(log, log.copyWith(reason: val)),
                      ),
                      Divider(color: AppColors.dividerColor),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
