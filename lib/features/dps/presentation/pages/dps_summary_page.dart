import 'dart:typed_data';

import 'package:excel/excel.dart' hide Border;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

import '../providers/dps_summary_providers.dart';

class DpsSummaryPage extends ConsumerStatefulWidget {
  const DpsSummaryPage({super.key});

  @override
  ConsumerState<DpsSummaryPage> createState() => _DpsSummaryPageState();
}

class _DpsSummaryPageState extends ConsumerState<DpsSummaryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _productSearchQuery = '';

  // Sort state
  String _sortColumn = 'date';
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(dpsSummaryFilterProvider);
    final summaryAsync = ref.watch(dpsSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Report Summary'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.download_rounded),
              tooltip: 'Export Excel (3 Sheets)',
              onPressed: () => _exportXlsx(context, ref),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ── 1. Date Range & Quick Preset Filters Card ───────────────────
            _buildDateFilterCard(context, ref, filter),
            const SizedBox(height: 14),

            // ── 2. Report Type Selector Tabs ────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textGrey,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.table_chart_outlined, size: 20),
                    text: 'Composite Report',
                  ),
                  Tab(
                    icon: Icon(Icons.inventory_2_outlined, size: 20),
                    text: 'Quantity Report',
                  ),
                  Tab(
                    icon: Icon(Icons.report_problem_outlined, size: 20),
                    text: 'Damage Report',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── 3. Main Split View (Sidebar + Content Area) ────────────────
            Expanded(
              child: summaryAsync.when(
                data: (DpsMatrixReportData data) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCompositeReportView(data, filter),
                        _buildQuantityReportView(data, filter),
                        _buildDamageReportView(data, filter),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (e, s) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.errorText,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load report summary: $e',
                        style: TextStyle(color: AppColors.errorText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilterCard(
    BuildContext context,
    WidgetRef ref,
    DpsSummaryFilter filter,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
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
                  context: context,
                  label: 'Start Date',
                  date: filter.startDate,
                  onSelect: (d) => ref
                      .read(dpsSummaryFilterProvider.notifier)
                      .setStartDate(d),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDatePicker(
                  context: context,
                  label: 'End Date',
                  date: filter.endDate,
                  onSelect: (d) =>
                      ref.read(dpsSummaryFilterProvider.notifier).setEndDate(d),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () =>
                    ref.read(dpsSummaryFilterProvider.notifier).clear(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.clear_all_rounded, size: 18),
                label: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime?> onSelect,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) onSelect(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: AppColors.primary,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        child: Text(
          date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Select date',
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildFixedLeftSidebar({
    required String title,
    required String searchHint,
    required String countText,
    required VoidCallback onSelectAll,
    required VoidCallback onClearAll,
    required List<Widget> listItems,
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(right: BorderSide(color: AppColors.dividerColor)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textBlack87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  countText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: TextField(
              onChanged: (val) => setState(() => _productSearchQuery = val),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 18),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.dividerColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: onSelectAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(60, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.select_all_rounded, size: 14),
                label: const Text('Select All', style: TextStyle(fontSize: 11)),
              ),
              TextButton.icon(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(60, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.deselect_rounded, size: 14),
                label: const Text('Clear All', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          Divider(height: 12, color: AppColors.dividerColor),
          Expanded(
            child: listItems.isEmpty
                ? const Center(
                    child: Text(
                      'No items match search',
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  )
                : ListView.separated(
                    itemCount: listItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                    itemBuilder: (context, index) => listItems[index],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItemTile({
    required String label,
    required bool selected,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!selected),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: selected,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? AppColors.primary : AppColors.textBlack87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompositeReportView(
    DpsMatrixReportData data,
    DpsSummaryFilter filter,
  ) {
    final vars = filter.compositeVariables;
    final availableVars = [
      {'key': 'qty', 'label': 'qty'},
      {'key': 'weight', 'label': 'weight (kg)'},
      {'key': 'gas_kg', 'label': 'gas (kg)'},
      {'key': 'wood_kg', 'label': 'wood (kg)'},
      {'key': 'gas_pkr', 'label': 'gas (pkr)'},
      {'key': 'wood_pkr', 'label': 'wood (pkr)'},
    ];

    final filteredVars = availableVars.where((v) {
      if (_productSearchQuery.isEmpty) return true;
      return v['label']!.toLowerCase().contains(
        _productSearchQuery.toLowerCase(),
      );
    }).toList();

    final rows = List<CompositeRow>.from(data.compositeRows);
    rows.sort((a, b) {
      int comp = 0;
      switch (_sortColumn) {
        case 'qty':
          comp = (a.qty ?? -1).compareTo(b.qty ?? -1);
          break;
        case 'weight':
          comp = (a.weight ?? -1).compareTo(b.weight ?? -1);
          break;
        case 'gas_kg':
          comp = (a.gasKg ?? -1).compareTo(b.gasKg ?? -1);
          break;
        case 'wood_kg':
          comp = (a.woodKg ?? -1).compareTo(b.woodKg ?? -1);
          break;
        case 'gas_pkr':
          comp = (a.gasPkr ?? -1).compareTo(b.gasPkr ?? -1);
          break;
        case 'wood_pkr':
          comp = (a.woodPkr ?? -1).compareTo(b.woodPkr ?? -1);
          break;
        case 'date':
        default:
          comp = a.date.compareTo(b.date);
          break;
      }
      return _sortAscending ? comp : -comp;
    });

    return Row(
      children: [
        _buildFixedLeftSidebar(
          title: 'Select Variables',
          searchHint: 'Search variables...',
          countText: '${vars.length} of ${availableVars.length}',
          onSelectAll: () => ref
              .read(dpsSummaryFilterProvider.notifier)
              .setAllCompositeVariables(true),
          onClearAll: () => ref
              .read(dpsSummaryFilterProvider.notifier)
              .setAllCompositeVariables(false),
          listItems: filteredVars.map((v) {
            final key = v['key']!;
            final selected = vars.contains(key);
            return _buildSidebarItemTile(
              label: v['label']!,
              selected: selected,
              onChanged: (_) => ref
                  .read(dpsSummaryFilterProvider.notifier)
                  .toggleCompositeVariable(key),
            );
          }).toList(),
        ),
        Expanded(
          child: vars.isEmpty
              ? _emptyState(
                  'No variables selected. Please check variables on the left.',
                )
              : rows.isEmpty
              ? _emptyState('No records available for the selected date range')
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStatePropertyAll(
                        AppColors.primary.withValues(alpha: 0.06),
                      ),
                      columnSpacing: 24,
                      horizontalMargin: 16,
                      border: TableBorder.all(
                        color: AppColors.dividerColor,
                        width: 1,
                      ),
                      columns: [
                        _buildSortableHeader('Date', 'date'),
                        if (vars.contains('qty'))
                          _buildSortableHeader('qty', 'qty'),
                        if (vars.contains('weight'))
                          _buildSortableHeader('weight', 'weight'),
                        if (vars.contains('gas_kg'))
                          _buildSortableHeader('gas (kg)', 'gas_kg'),
                        if (vars.contains('wood_kg'))
                          _buildSortableHeader('wood (kg)', 'wood_kg'),
                        if (vars.contains('gas_pkr'))
                          _buildSortableHeader('gas (pkr)', 'gas_pkr'),
                        if (vars.contains('wood_pkr'))
                          _buildSortableHeader('wood (pkr)', 'wood_pkr'),
                      ],
                      rows: [
                        ...rows.map(
                          (row) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  row.dateStr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (vars.contains('qty'))
                                _buildValueCell(row.qty?.toStringAsFixed(0)),
                              if (vars.contains('weight'))
                                _buildValueCell(
                                  row.weight != null
                                      ? '${row.weight!.toStringAsFixed(1)} KG'
                                      : null,
                                ),
                              if (vars.contains('gas_kg'))
                                _buildValueCell(row.gasKg?.toStringAsFixed(1)),
                              if (vars.contains('wood_kg'))
                                _buildValueCell(row.woodKg?.toStringAsFixed(1)),
                              if (vars.contains('gas_pkr'))
                                _buildValueCell(row.gasPkr?.toStringAsFixed(2)),
                              if (vars.contains('wood_pkr'))
                                _buildValueCell(
                                  row.woodPkr?.toStringAsFixed(2),
                                ),
                            ],
                          ),
                        ),
                        DataRow(
                          color: WidgetStatePropertyAll(
                            AppColors.totalSummaryBackground,
                          ),
                          cells: [
                            const DataCell(
                              Text(
                                'Total Sum',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            if (vars.contains('qty'))
                              DataCell(
                                Text(
                                  (data.compositeTotals['qty'] ?? 0)
                                      .toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (vars.contains('weight'))
                              DataCell(
                                Text(
                                  '${(data.compositeTotals['weight'] ?? 0).toStringAsFixed(1)} KG',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (vars.contains('gas_kg'))
                              DataCell(
                                Text(
                                  (data.compositeTotals['gas_kg'] ?? 0)
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (vars.contains('wood_kg'))
                              DataCell(
                                Text(
                                  (data.compositeTotals['wood_kg'] ?? 0)
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (vars.contains('gas_pkr'))
                              DataCell(
                                Text(
                                  (data.compositeTotals['gas_pkr'] ?? 0)
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (vars.contains('wood_pkr'))
                              DataCell(
                                Text(
                                  (data.compositeTotals['wood_pkr'] ?? 0)
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
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
      ],
    );
  }

  Widget _buildQuantityReportView(
    DpsMatrixReportData data,
    DpsSummaryFilter filter,
  ) {
    final selectedProductIds = filter.quantityProductIds;
    final products = data.allProducts;
    final filteredProducts = products
        .where(
          (p) =>
              _productSearchQuery.isEmpty ||
              p.name.toLowerCase().contains(_productSearchQuery.toLowerCase()),
        )
        .toList();
    final selectedProductsList = products
        .where((p) => selectedProductIds.contains(p.id))
        .toList();

    final rows = List<ProductMatrixRow>.from(data.quantityRows);
    rows.sort((a, b) {
      int comp = 0;
      if (_sortColumn.startsWith('product_')) {
        final pId = int.tryParse(_sortColumn.replaceFirst('product_', ''));
        if (pId != null)
          comp = (a.values[pId] ?? -1).compareTo(b.values[pId] ?? -1);
      } else
        comp = a.date.compareTo(b.date);
      return _sortAscending ? comp : -comp;
    });

    return Row(
      children: [
        _buildFixedLeftSidebar(
          title: 'Product Selection',
          searchHint: 'Search products...',
          countText: '${selectedProductIds.length} of ${products.length}',
          onSelectAll: () => ref
              .read(dpsSummaryFilterProvider.notifier)
              .setAllQuantityProducts(products.map((p) => p.id).toList(), true),
          onClearAll: () => ref
              .read(dpsSummaryFilterProvider.notifier)
              .setAllQuantityProducts(
                products.map((p) => p.id).toList(),
                false,
              ),
          listItems: filteredProducts.map((p) {
            final selected = selectedProductIds.contains(p.id);
            return _buildSidebarItemTile(
              label: p.name,
              selected: selected,
              onChanged: (_) => ref
                  .read(dpsSummaryFilterProvider.notifier)
                  .toggleQuantityProduct(p.id),
            );
          }).toList(),
        ),
        Expanded(
          child: selectedProductIds.isEmpty
              ? _emptyState(
                  'No products selected.\nPlease select products on the left sidebar to view quantity report.',
                )
              : rows.isEmpty
              ? _emptyState(
                  'No production records found for the selected dates',
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStatePropertyAll(
                        AppColors.primary.withValues(alpha: 0.06),
                      ),
                      columnSpacing: 20,
                      horizontalMargin: 16,
                      border: TableBorder.all(
                        color: AppColors.dividerColor,
                        width: 1,
                      ),
                      columns: [
                        _buildSortableHeader('Date', 'date'),
                        for (final p in selectedProductsList)
                          _buildSortableHeader(p.name, 'product_${p.id}'),
                      ],
                      rows: [
                        ...rows.map(
                          (row) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  row.dateStr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              for (final p in selectedProductsList)
                                _buildValueCell(
                                  row.values[p.id]?.toStringAsFixed(0),
                                ),
                            ],
                          ),
                        ),
                        DataRow(
                          color: WidgetStatePropertyAll(
                            AppColors.totalSummaryBackground,
                          ),
                          cells: [
                            const DataCell(
                              Text(
                                'Total Sum',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            for (final p in selectedProductsList)
                              DataCell(
                                Text(
                                  (data.quantityTotals[p.id] ?? 0)
                                      .toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
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
      ],
    );
  }

  Widget _buildDamageReportView(
    DpsMatrixReportData data,
    DpsSummaryFilter filter,
  ) {
    final selectedProductIds = filter.damageProductIds;
    final products = data.allProducts;
    final filteredProducts = products
        .where(
          (p) =>
              _productSearchQuery.isEmpty ||
              p.name.toLowerCase().contains(_productSearchQuery.toLowerCase()),
        )
        .toList();
    final selectedProductsList = products
        .where((p) => selectedProductIds.contains(p.id))
        .toList();

    final rows = List<ProductMatrixRow>.from(data.damageRows);
    rows.sort((a, b) {
      int comp = 0;
      if (_sortColumn.startsWith('product_')) {
        final pId = int.tryParse(_sortColumn.replaceFirst('product_', ''));
        if (pId != null)
          comp = (a.values[pId] ?? -1).compareTo(b.values[pId] ?? -1);
      } else
        comp = a.date.compareTo(b.date);
      return _sortAscending ? comp : -comp;
    });

    return Row(
      children: [
        _buildFixedLeftSidebar(
          title: 'Damage Products',
          searchHint: 'Search products...',
          countText: '${selectedProductIds.length} of ${products.length}',
          onSelectAll: () => ref
              .read(dpsSummaryFilterProvider.notifier)
              .setAllDamageProducts(products.map((p) => p.id).toList(), true),
          onClearAll: () => ref
              .read(dpsSummaryFilterProvider.notifier)
              .setAllDamageProducts(products.map((p) => p.id).toList(), false),
          listItems: filteredProducts.map((p) {
            final selected = selectedProductIds.contains(p.id);
            return _buildSidebarItemTile(
              label: p.name,
              selected: selected,
              onChanged: (_) => ref
                  .read(dpsSummaryFilterProvider.notifier)
                  .toggleDamageProduct(p.id),
            );
          }).toList(),
        ),
        Expanded(
          child: selectedProductIds.isEmpty
              ? _emptyState(
                  'No products selected.\nPlease select products on the left sidebar to view damage report.',
                )
              : rows.isEmpty
              ? _emptyState('No damage records found for the selected dates')
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStatePropertyAll(
                        AppColors.errorBackground.withValues(alpha: 0.08),
                      ),
                      columnSpacing: 20,
                      horizontalMargin: 16,
                      border: TableBorder.all(
                        color: AppColors.dividerColor,
                        width: 1,
                      ),
                      columns: [
                        _buildSortableHeader('Date', 'date'),
                        for (final p in selectedProductsList)
                          _buildSortableHeader(p.name, 'product_${p.id}'),
                      ],
                      rows: [
                        ...rows.map(
                          (row) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  row.dateStr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              for (final p in selectedProductsList)
                                _buildValueCell(
                                  row.values[p.id]?.toStringAsFixed(0),
                                  textColor: AppColors.errorText,
                                  tooltip: row.tooltips?[p.id],
                                ),
                            ],
                          ),
                        ),
                        DataRow(
                          color: WidgetStatePropertyAll(
                            AppColors.errorBackground.withValues(alpha: 0.12),
                          ),
                          cells: [
                            const DataCell(
                              Text(
                                'Total Sum',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.errorText,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            for (final p in selectedProductsList)
                              DataCell(
                                Text(
                                  (data.damageTotals[p.id] ?? 0)
                                      .toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.errorText,
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
      ],
    );
  }

  DataColumn _buildSortableHeader(String title, String columnKey) {
    final isSelected = _sortColumn == columnKey;
    return DataColumn(
      label: InkWell(
        onTap: () => _onSort(columnKey),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? AppColors.primary : AppColors.textBlack87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isSelected
                  ? (_sortAscending
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded)
                  : Icons.unfold_more_rounded,
              size: 14,
              color: isSelected ? AppColors.primary : AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }

  DataCell _buildValueCell(String? value, {Color? textColor, String? tooltip}) {
    if (value == null) {
      return DataCell(
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '-',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }
    final textWidget = Text(
      value,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: textColor ?? AppColors.textBlack87,
        fontSize: 13,
      ),
    );
    if (tooltip == null || tooltip.isEmpty) {
      return DataCell(textWidget);
    }
    return DataCell(
      _HoverTooltipCell(label: value, tooltip: tooltip, textColor: textColor),
    );
  }

  Widget _emptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Future<void> _exportXlsx(BuildContext context, WidgetRef ref) async {
    try {
      final matrixData = await ref.read(dpsSummaryProvider.future);
      final filter = ref.read(dpsSummaryFilterProvider);
      final excel = Excel.createExcel();

      List<CellValue?> toCellValues(List<dynamic> list) => list
          .map<CellValue?>(
            (e) => (e == null || e == '-')
                ? TextCellValue('-')
                : (e is num
                      ? DoubleCellValue(e.toDouble())
                      : TextCellValue(e.toString())),
          )
          .toList();

      // Composite sheet
      final sheetComposite = excel['Composite Report'];
      final compVars = filter.compositeVariables.isEmpty
          ? {'qty', 'weight', 'gas_kg', 'wood_kg', 'gas_pkr', 'wood_pkr'}
          : filter.compositeVariables;
      final compHeaders = <dynamic>['Date'];
      if (compVars.contains('qty')) compHeaders.add('qty');
      if (compVars.contains('weight')) compHeaders.add('weight (kg)');
      if (compVars.contains('gas_kg')) compHeaders.add('gas (kg)');
      if (compVars.contains('wood_kg')) compHeaders.add('wood (kg)');
      if (compVars.contains('gas_pkr')) compHeaders.add('gas (pkr)');
      if (compVars.contains('wood_pkr')) compHeaders.add('wood (pkr)');
      sheetComposite.appendRow(toCellValues(compHeaders));
      for (final r in matrixData.compositeRows) {
        final rowVals = <dynamic>[r.dateStr];
        if (compVars.contains('qty')) rowVals.add(r.qty ?? '-');
        if (compVars.contains('weight')) rowVals.add(r.weight ?? '-');
        if (compVars.contains('gas_kg')) rowVals.add(r.gasKg ?? '-');
        if (compVars.contains('wood_kg')) rowVals.add(r.woodKg ?? '-');
        if (compVars.contains('gas_pkr')) rowVals.add(r.gasPkr ?? '-');
        if (compVars.contains('wood_pkr')) rowVals.add(r.woodPkr ?? '-');
        sheetComposite.appendRow(toCellValues(rowVals));
      }

      // Quantity sheet
      final sheetQty = excel['Quantity Report'];
      final selectedQtyProds = filter.quantityProductIds.isEmpty
          ? matrixData.allProducts
          : matrixData.allProducts
                .where((p) => filter.quantityProductIds.contains(p.id))
                .toList();
      sheetQty.appendRow(
        toCellValues(['Date', ...selectedQtyProds.map((p) => p.name)]),
      );
      for (final r in matrixData.quantityRows) {
        sheetQty.appendRow(
          toCellValues([
            r.dateStr,
            ...selectedQtyProds.map((p) => r.values[p.id] ?? '-'),
          ]),
        );
      }

      // Damage sheet
      final sheetDam = excel['Damage Report'];
      final selectedDamProds = filter.damageProductIds.isEmpty
          ? matrixData.allProducts
          : matrixData.allProducts
                .where((p) => filter.damageProductIds.contains(p.id))
                .toList();
      sheetDam.appendRow(
        toCellValues(['Date', ...selectedDamProds.map((p) => p.name)]),
      );
      for (final r in matrixData.damageRows) {
        sheetDam.appendRow(
          toCellValues([
            r.dateStr,
            ...selectedDamProds.map((p) => r.values[p.id] ?? '-'),
          ]),
        );
      }

      if (excel.sheets.containsKey('Sheet1')) excel.delete('Sheet1');
      final bytes = excel.encode();
      if (bytes == null) throw Exception('Failed to generate excel file');

      final fileName =
          'DPS_Summary_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}';

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(bytes),
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Excel summary exported: $fileName.xlsx'),
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
}

// ── Custom hover tooltip cell for damage reasons ────────────────────────────
class _HoverTooltipCell extends StatefulWidget {
  final String label;
  final String tooltip;
  final Color? textColor;

  const _HoverTooltipCell({
    required this.label,
    required this.tooltip,
    this.textColor,
  });

  @override
  State<_HoverTooltipCell> createState() => _HoverTooltipCellState();
}

class _HoverTooltipCellState extends State<_HoverTooltipCell> {
  OverlayEntry? _overlay;
  final _key = GlobalKey();

  void _showOverlay() {
    _removeOverlay();
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx,
        top: offset.dy - 6,
        child: FractionalTranslation(
          translation: const Offset(0, -1),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 13,
                        color: Color(0xFFFFB74D),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Damage Reason',
                        style: TextStyle(
                          color: Color(0xFFFFB74D),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.tooltip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _key,
      onEnter: (_) => _showOverlay(),
      onExit: (_) => _removeOverlay(),
      cursor: SystemMouseCursors.help,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: widget.textColor ?? AppColors.textBlack87,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.info_outline_rounded,
            size: 13,
            color: (widget.textColor ?? AppColors.textBlack87).withValues(
              alpha: 0.55,
            ),
          ),
        ],
      ),
    );
  }
}
