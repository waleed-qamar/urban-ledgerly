import 'dart:io';

import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';

import '../providers/dps_summary_providers.dart';
import '../providers/dps_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../raw_material/presentation/providers/raw_material_providers.dart';

class DpsSummaryPage extends ConsumerWidget {
  const DpsSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(dpsSummaryFilterProvider);
    final summaryAsync = ref.watch(dpsSummaryProvider);
    final reportsAsync = ref.watch(dpsReportsProvider);
    final productsAsync = ref.watch(getAllProductsProvider);
    final rawMaterialsAsync = ref.watch(getAllRawMaterialsProvider);

    final reportDates = reportsAsync.maybeWhen(
      data: (reports) => {
        for (final report in reports)
          if (report.id != null) report.id!: report.reportDate,
      },
      orElse: () => <int, DateTime>{},
    );

    final productNames = productsAsync.maybeWhen(
      data: (products) => {for (final p in products) p.id: p.name},
      orElse: () => <int, String>{},
    );

    final materialNames = rawMaterialsAsync.maybeWhen(
      data: (materials) => {for (final m in materials) m.id: m.name},
      orElse: () => <int, String>{},
    );

    final materialUnits = rawMaterialsAsync.maybeWhen(
      data: (materials) => {for (final m in materials) m.id: m.unit},
      orElse: () => <int, String>{},
    );

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Report Summary'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.download),
              tooltip: 'Export XLSX',
              onPressed: () => _exportXlsx(context, ref),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ── Filters card ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDatePicker(
                          context,
                          ref,
                          true,
                          filter.startDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDatePicker(
                          context,
                          ref,
                          false,
                          filter.endDate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _FilterLabel(text: 'Filter by Product'),
                  const SizedBox(height: 6),
                  productsAsync.when(
                    data: (products) =>
                        _buildProductChips(context, ref, products),
                    loading: () => const SizedBox.shrink(),
                    error: (e, s) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 10),
                  _FilterLabel(text: 'Filter by Raw Material'),
                  const SizedBox(height: 6),
                  rawMaterialsAsync.when(
                    data: (materials) =>
                        _buildMaterialChips(context, ref, materials),
                    loading: () => const SizedBox.shrink(),
                    error: (e, s) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => ref.refresh(dpsSummaryProvider),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.filter_alt_outlined, size: 18),
                      label: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Results ──────────────────────────────────────────────
            Expanded(
              child: summaryAsync.when(
                data: (summary) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.textGrey,
                            indicatorColor: AppColors.primary,
                            tabs: const [
                              Tab(text: 'Production'),
                              Tab(text: 'Consumption'),
                              Tab(text: 'Damages'),
                            ],
                          ),
                          Divider(height: 1, color: AppColors.dividerColor),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildProductionList(
                                  context,
                                  summary,
                                  reportDates,
                                  productNames,
                                ),
                                _buildConsumptionList(
                                  context,
                                  summary,
                                  reportDates,
                                  materialNames,
                                  materialUnits,
                                ),
                                _buildDamagesList(
                                  context,
                                  summary,
                                  reportDates,
                                  productNames,
                                  materialNames,
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: AppColors.dividerColor),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _TotalPill(
                                  label: 'Production',
                                  value: summary.productionTotal
                                      .toStringAsFixed(2),
                                  bgColor: AppColors.totalSummaryBackground,
                                  textColor: AppColors.successText,
                                ),
                                _TotalPill(
                                  label: 'Consumption',
                                  value: summary.consumptionTotal
                                      .toStringAsFixed(2),
                                  bgColor: AppColors.iconBackground,
                                  textColor: AppColors.iconColor,
                                ),
                                _TotalPill(
                                  label: 'Damages',
                                  value: summary.damagesTotal.toStringAsFixed(
                                    2,
                                  ),
                                  bgColor: AppColors.errorBackground.withValues(
                                    alpha: 0.12,
                                  ),
                                  textColor: AppColors.errorText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (e, s) => Center(
                  child: Text(
                    'Error: $e',
                    style: TextStyle(color: AppColors.errorText),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportXlsx(BuildContext context, WidgetRef ref) async {
    try {
      final res = await ref.read(dpsSummaryProvider.future);
      final reports = await ref.read(dpsReportsProvider.future);
      final products = await ref.read(getAllProductsProvider.future);
      final materials = await ref.read(getAllRawMaterialsProvider.future);
      final reportDateById = {
        for (final report in reports)
          if (report.id != null) report.id!: report.reportDate,
      };
      final pNames = {for (final p in products) p.id: p.name};
      final mNames = {for (final m in materials) m.id: m.name};
      final mUnits = {for (final m in materials) m.id: m.unit};

      final excel = Excel.createExcel();
      final Sheet sheet = excel['Summary'];
      (sheet as dynamic).appendRow(<dynamic>[
        'date',
        'item_name',
        'quantity',
        'extra',
      ]);

      for (final p in res.production) {
        (sheet as dynamic).appendRow(<dynamic>[
          _formatDate(reportDateById[p.reportId]),
          pNames[p.productId] ?? 'Product ${p.productId}',
          p.quantity.toString(),
          '',
        ]);
      }

      for (final c in res.consumption) {
        final unit = mUnits[c.rawMaterialId] ?? 'kg';
        (sheet as dynamic).appendRow(<dynamic>[
          _formatDate(reportDateById[c.reportId]),
          mNames[c.rawMaterialId] ?? 'Raw ${c.rawMaterialId}',
          '${c.quantity} $unit',
          '',
        ]);
      }

      for (final d in res.damages) {
        final name = d.itemType == 'product'
            ? (pNames[d.itemId] ?? 'Product ${d.itemId}')
            : (mNames[d.itemId] ?? 'Raw ${d.itemId}');
        (sheet as dynamic).appendRow(<dynamic>[
          _formatDate(reportDateById[d.reportId]),
          name,
          d.quantity.toString(),
          d.reason ?? '',
        ]);
      }

      final bytes = excel.encode();
      if (bytes == null) throw Exception('Failed to generate xlsx');

      final downloadsDir = Directory(
        '${Platform.environment['HOME']}/Downloads',
      );
      await downloadsDir.create(recursive: true);
      final file = File(
        '${downloadsDir.path}/dps_summary_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      );
      await file.writeAsBytes(bytes, flush: true);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to ${file.path}'),
          backgroundColor: AppColors.successText,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.errorBackground,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildDatePicker(
    BuildContext context,
    WidgetRef ref,
    bool isStart,
    DateTime? initial,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: initial ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          if (isStart) {
            ref.read(dpsSummaryFilterProvider.notifier).setStartDate(picked);
          } else {
            ref.read(dpsSummaryFilterProvider.notifier).setEndDate(picked);
          }
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: isStart ? 'Start Date' : 'End Date',
          prefixIcon: Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: AppColors.primary,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        child: Text(
          initial != null
              ? DateFormat('yyyy-MM-dd').format(initial)
              : 'Select ${isStart ? 'Start' : 'End'}',
        ),
      ),
    );
  }

  Widget _buildProductChips(
    BuildContext context,
    WidgetRef ref,
    List products,
  ) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final p in products)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Consumer(
                builder: (context, ref, _) {
                  final selected = ref
                      .watch(dpsSummaryFilterProvider)
                      .productIds
                      .contains(p.id);
                  return _themedChoiceChip(
                    label: p.name ?? 'Unnamed',
                    selected: selected,
                    onSelected: (_) => ref
                        .read(dpsSummaryFilterProvider.notifier)
                        .toggleProduct(p.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMaterialChips(
    BuildContext context,
    WidgetRef ref,
    List materials,
  ) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final m in materials)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Consumer(
                builder: (context, ref, _) {
                  final selected = ref
                      .watch(dpsSummaryFilterProvider)
                      .rawMaterialIds
                      .contains(m.id);
                  return _themedChoiceChip(
                    label: m.name ?? 'Unnamed',
                    selected: selected,
                    onSelected: (_) => ref
                        .read(dpsSummaryFilterProvider.notifier)
                        .toggleRawMaterial(m.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _themedChoiceChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.badgeBackground,
      labelStyle: TextStyle(
        color: selected ? AppColors.textWhite : AppColors.textBlack87,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.dividerColor,
        ),
      ),
      side: BorderSide.none,
    );
  }

  Widget _buildProductionList(
    BuildContext context,
    DpsSummaryResult summary,
    Map<int, DateTime> reportDates,
    Map<int, String> productNames,
  ) {
    if (summary.production.isEmpty) {
      return _emptyState('No production entries');
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: summary.production.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: AppColors.dividerColor),
      itemBuilder: (context, index) {
        final e = summary.production[index];
        final name = productNames[e.productId] ?? 'Product ${e.productId}';
        return ListTile(
          leading: _iconBadge(
            Icons.production_quantity_limits,
            AppColors.successText,
          ),
          title: Text(name),
          subtitle: Text(_formatDate(reportDates[e.reportId])),
          trailing: Text(
            e.quantity.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.successText,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConsumptionList(
    BuildContext context,
    DpsSummaryResult summary,
    Map<int, DateTime> reportDates,
    Map<int, String> materialNames,
    Map<int, String> materialUnits,
  ) {
    if (summary.consumption.isEmpty) {
      return _emptyState('No consumption entries');
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: summary.consumption.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: AppColors.dividerColor),
      itemBuilder: (context, index) {
        final e = summary.consumption[index];
        final name = materialNames[e.rawMaterialId] ?? 'Raw ${e.rawMaterialId}';
        final unit = materialUnits[e.rawMaterialId] ?? 'kg';
        return ListTile(
          leading: _iconBadge(Icons.inventory_2_outlined, AppColors.iconColor),
          title: Text(name),
          subtitle: Text(_formatDate(reportDates[e.reportId])),
          trailing: Text(
            '${e.quantity} $unit',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.iconColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDamagesList(
    BuildContext context,
    DpsSummaryResult summary,
    Map<int, DateTime> reportDates,
    Map<int, String> productNames,
    Map<int, String> materialNames,
  ) {
    if (summary.damages.isEmpty) {
      return _emptyState('No damage entries');
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: summary.damages.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: AppColors.dividerColor),
      itemBuilder: (context, index) {
        final e = summary.damages[index];
        final name = e.itemType == 'product'
            ? (productNames[e.itemId] ?? 'Product ${e.itemId}')
            : (materialNames[e.itemId] ?? 'Raw ${e.itemId}');
        return ListTile(
          leading: _iconBadge(
            Icons.report_problem_outlined,
            AppColors.errorText,
          ),
          title: Text(name),
          subtitle: Text(
            '${_formatDate(reportDates[e.reportId])}${e.reason != null && e.reason!.isNotEmpty ? ' · ${e.reason}' : ''}',
          ),
          trailing: Text(
            e.quantity.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.errorText,
            ),
          ),
        );
      },
    );
  }

  Widget _iconBadge(IconData icon, Color color) {
    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.12),
      child: Icon(icon, size: 18, color: color),
    );
  }

  Widget _emptyState(String message) {
    return Center(
      child: Text(message, style: TextStyle(color: AppColors.textGrey)),
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

class _FilterLabel extends StatelessWidget {
  final String text;
  const _FilterLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: AppColors.textBlack87,
      ),
    );
  }
}

class _TotalPill extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;
  final Color textColor;

  const _TotalPill({
    required this.label,
    required this.value,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withValues(alpha: 0.85),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
