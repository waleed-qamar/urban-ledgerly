import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export XLSX',
            onPressed: () async {
              try {
                final res = await ref.read(dpsSummaryProvider.future);
                final reports = await ref.read(dpsReportsProvider.future);
                final products = await ref.read(getAllProductsProvider.future);
                final materials = await ref.read(
                  getAllRawMaterialsProvider.future,
                );
                final reportDateById = {
                  for (final report in reports)
                    if (report.id != null) report.id!: report.reportDate,
                };
                final pNames = {for (final p in products) p.id: p.name};
                final mNames = {for (final m in materials) m.id: m.name};

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
                  (sheet as dynamic).appendRow(<dynamic>[
                    _formatDate(reportDateById[c.reportId]),
                    mNames[c.rawMaterialId] ?? 'Raw ${c.rawMaterialId}',
                    c.quantity.toString(),
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
                  SnackBar(content: Text('Saved to ${file.path}')),
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(context, ref, true, filter.startDate),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDatePicker(context, ref, false, filter.endDate),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filter by Product:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            productsAsync.when(
              data: (products) => _buildProductChips(context, ref, products),
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filter by Raw Material:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            rawMaterialsAsync.when(
              data: (materials) => _buildMaterialChips(context, ref, materials),
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(dpsSummaryProvider),
              icon: const Icon(Icons.search),
              label: const Text('Apply Filters'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: summaryAsync.when(
                data: (summary) {
                  return DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Production'),
                            Tab(text: 'Consumption'),
                            Tab(text: 'Damages'),
                          ],
                        ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text(
                                  'Production ${summary.productionTotal.toStringAsFixed(2)}',
                                ),
                              ),
                              Chip(
                                label: Text(
                                  'Consumption ${summary.consumptionTotal.toStringAsFixed(2)}',
                                ),
                              ),
                              Chip(
                                label: Text(
                                  'Damages ${summary.damagesTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                backgroundColor: Colors.red.withValues(
                                  alpha: 0.08,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    WidgetRef ref,
    bool isStart,
    DateTime? initial,
  ) {
    return InkWell(
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
        ),
        child: Text(
          initial != null
              ? DateFormat('yyyy-MM-dd').format(initial)
              : 'Select ${isStart ? 'Start' : 'End'} Date',
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
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 4),
          for (final p in products)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Consumer(
                builder: (context, ref, _) {
                  final selected = ref
                      .watch(dpsSummaryFilterProvider)
                      .productIds
                      .contains(p.id);
                  return ChoiceChip(
                    label: Text(p.name ?? 'Unnamed'),
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
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 4),
          for (final m in materials)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Consumer(
                builder: (context, ref, _) {
                  final selected = ref
                      .watch(dpsSummaryFilterProvider)
                      .rawMaterialIds
                      .contains(m.id);
                  return ChoiceChip(
                    label: Text(m.name ?? 'Unnamed'),
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

  Widget _buildProductionList(
    BuildContext context,
    DpsSummaryResult summary,
    Map<int, DateTime> reportDates,
    Map<int, String> productNames,
  ) {
    if (summary.production.isEmpty) {
      return const Center(child: Text('No production entries'));
    }
    return ListView.builder(
      itemCount: summary.production.length,
      itemBuilder: (context, index) {
        final e = summary.production[index];
        final name = productNames[e.productId] ?? 'Product ${e.productId}';
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.production_quantity_limits, size: 18),
          ),
          title: Text(name),
          subtitle: Text(_formatDate(reportDates[e.reportId])),
          trailing: Text(e.quantity.toString()),
        );
      },
    );
  }

  Widget _buildConsumptionList(
    BuildContext context,
    DpsSummaryResult summary,
    Map<int, DateTime> reportDates,
    Map<int, String> materialNames,
  ) {
    if (summary.consumption.isEmpty) {
      return const Center(child: Text('No consumption entries'));
    }
    return ListView.builder(
      itemCount: summary.consumption.length,
      itemBuilder: (context, index) {
        final e = summary.consumption[index];
        final name = materialNames[e.rawMaterialId] ?? 'Raw ${e.rawMaterialId}';
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.inventory_2, size: 18)),
          title: Text(name),
          subtitle: Text(_formatDate(reportDates[e.reportId])),
          trailing: Text(e.quantity.toString()),
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
      return const Center(child: Text('No damage entries'));
    }
    return ListView.builder(
      itemCount: summary.damages.length,
      itemBuilder: (context, index) {
        final e = summary.damages[index];
        final name = e.itemType == 'product'
            ? (productNames[e.itemId] ?? 'Product ${e.itemId}')
            : (materialNames[e.itemId] ?? 'Raw ${e.itemId}');
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.report_problem, size: 18, color: Colors.red),
          ),
          title: Text(name),
          subtitle: Text(
            '${_formatDate(reportDates[e.reportId])}${e.reason != null && e.reason!.isNotEmpty ? '\n${e.reason}' : ''}',
          ),
          trailing: Text(
            e.quantity.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
