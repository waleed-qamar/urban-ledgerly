import 'package:flutter/foundation.dart';
import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dps_providers.dart';
import '../../domain/entities/dps_models.dart';

part 'dps_summary_providers.g.dart';

@immutable
class DpsSummaryFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final Set<int> productIds;
  final Set<int> rawMaterialIds;

  const DpsSummaryFilter({
    this.startDate,
    this.endDate,
    this.productIds = const {},
    this.rawMaterialIds = const {},
  });

  DpsSummaryFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    Set<int>? productIds,
    Set<int>? rawMaterialIds,
  }) {
    return DpsSummaryFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      productIds: productIds ?? this.productIds,
      rawMaterialIds: rawMaterialIds ?? this.rawMaterialIds,
    );
  }
}

@riverpod
class DpsSummaryFilterNotifier extends _$DpsSummaryFilterNotifier {
  @override
  DpsSummaryFilter build() => const DpsSummaryFilter();

  void setStartDate(DateTime? date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime? date) {
    state = state.copyWith(endDate: date);
  }

  void toggleProduct(int id) {
    final newSet = Set<int>.from(state.productIds);
    if (!newSet.add(id)) newSet.remove(id);
    state = state.copyWith(productIds: newSet);
  }

  void toggleRawMaterial(int id) {
    final newSet = Set<int>.from(state.rawMaterialIds);
    if (!newSet.add(id)) newSet.remove(id);
    state = state.copyWith(rawMaterialIds: newSet);
  }

  void clear() {
    state = const DpsSummaryFilter();
  }
}

class DpsSummaryResult {
  final List<DpsProductionLog> production;
  final List<DpsConsumptionLog> consumption;
  final List<DpsDamageLog> damages;

  DpsSummaryResult({
    required this.production,
    required this.consumption,
    required this.damages,
  });

  double get productionTotal =>
      production.fold(0.0, (p, e) => p + (e.quantity ?? 0));
  double get consumptionTotal =>
      consumption.fold(0.0, (p, e) => p + (e.quantity ?? 0));
  double get damagesTotal => damages.fold(0.0, (p, e) => p + (e.quantity ?? 0));
}

@riverpod
Future<DpsSummaryResult> dpsSummary(Ref ref) async {
  final repo = ref.watch(dpsRepositoryProvider);
  final filter = ref.watch(dpsSummaryFilterProvider);

  // Load all reports and filter by date range
  final allReports = await repo.getReports();
  final filtered = allReports.where((r) {
    final date = r.reportDate;
    if (filter.startDate != null && date.isBefore(filter.startDate!))
      return false;
    if (filter.endDate != null && date.isAfter(filter.endDate!)) return false;
    return true;
  }).toList();

  final reportIds = [
    for (final r in filtered)
      if (r.id != null) r.id!,
  ];

  final prodLogs = await repo.getProductionLogsForReportIds(reportIds);
  final consLogs = await repo.getConsumptionLogsForReportIds(reportIds);
  final damLogs = await repo.getDamageLogsForReportIds(reportIds);

  // Apply client-side filtering by product/raw material ids if selected
  final prodFiltered = filter.productIds.isEmpty
      ? prodLogs
      : prodLogs.where((l) => filter.productIds.contains(l.productId)).toList();

  final consFiltered = filter.rawMaterialIds.isEmpty
      ? consLogs
      : consLogs
            .where((l) => filter.rawMaterialIds.contains(l.rawMaterialId))
            .toList();

  final damFiltered = damLogs.where((l) {
    if (l.itemType == 'product' && filter.productIds.isNotEmpty) {
      return filter.productIds.contains(l.itemId);
    }
    if (l.itemType == 'raw_material' && filter.rawMaterialIds.isNotEmpty) {
      return filter.rawMaterialIds.contains(l.itemId);
    }
    return filter.productIds.isEmpty && filter.rawMaterialIds.isEmpty;
  }).toList();

  return DpsSummaryResult(
    production: prodFiltered,
    consumption: consFiltered,
    damages: damFiltered,
  );
}
