import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../raw_material/domain/entities/raw_material_entity.dart';
import '../../../raw_material/presentation/providers/raw_material_providers.dart';
import '../../domain/entities/dps_models.dart';
import 'dps_providers.dart';

part 'dps_summary_providers.g.dart';

@immutable
class DpsSummaryFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final Set<String> compositeVariables;
  final Set<int> quantityProductIds;
  final Set<int> damageProductIds;

  const DpsSummaryFilter({
    this.startDate,
    this.endDate,
    this.compositeVariables = const {
      'qty',
      'weight',
      'gas_kg',
      'wood_kg',
      'gas_pkr',
      'wood_pkr',
    },
    this.quantityProductIds = const {},
    this.damageProductIds = const {},
  });

  DpsSummaryFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    Set<String>? compositeVariables,
    Set<int>? quantityProductIds,
    Set<int>? damageProductIds,
  }) {
    return DpsSummaryFilter(
      startDate: startDate ?? this.startDate, 
      endDate: endDate ?? this.endDate,
      compositeVariables: compositeVariables ?? this.compositeVariables,
      quantityProductIds: quantityProductIds ?? this.quantityProductIds,
      damageProductIds: damageProductIds ?? this.damageProductIds,
    );
  }
}

@riverpod
class DpsSummaryFilterNotifier extends _$DpsSummaryFilterNotifier {
  @override
  DpsSummaryFilter build() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return DpsSummaryFilter(startDate: startOfMonth, endDate: now);
  }

  void setStartDate(DateTime? date) {
    state = DpsSummaryFilter(
      startDate: date,
      endDate: state.endDate,
      compositeVariables: state.compositeVariables,
      quantityProductIds: state.quantityProductIds,
      damageProductIds: state.damageProductIds,
    );
  }

  void setEndDate(DateTime? date) {
    state = DpsSummaryFilter(
      startDate: state.startDate,
      endDate: date,
      compositeVariables: state.compositeVariables,
      quantityProductIds: state.quantityProductIds,
      damageProductIds: state.damageProductIds,
    );
  }

  void toggleCompositeVariable(String varName) {
    final set = Set<String>.from(state.compositeVariables);
    if (!set.add(varName)) set.remove(varName);
    state = state.copyWith(compositeVariables: set);
  }

  void setAllCompositeVariables(bool select) {
    if (select) {
      state = state.copyWith(
        compositeVariables: {
          'qty',
          'weight',
          'gas_kg',
          'wood_kg',
          'gas_pkr',
          'wood_pkr',
        },
      );
    } else {
      state = state.copyWith(compositeVariables: {});
    }
  }

  void toggleQuantityProduct(int id) {
    final set = Set<int>.from(state.quantityProductIds);
    if (!set.add(id)) set.remove(id);
    state = state.copyWith(quantityProductIds: set);
  }

  void setAllQuantityProducts(List<int> allIds, bool select) {
    state = state.copyWith(
      quantityProductIds: select ? Set<int>.from(allIds) : {},
    );
  }

  void toggleDamageProduct(int id) {
    final set = Set<int>.from(state.damageProductIds);
    if (!set.add(id)) set.remove(id);
    state = state.copyWith(damageProductIds: set);
  }

  void setAllDamageProducts(List<int> allIds, bool select) {
    state = state.copyWith(
      damageProductIds: select ? Set<int>.from(allIds) : {},
    );
  }

  void clear() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    state = DpsSummaryFilter(startDate: startOfMonth, endDate: now);
  }
}

/// Raw data container to decouple fetching from UI transformations
class DpsRawData {
  final List<DpsReport> filteredReports;
  final List<DpsProductionLog> prodLogs;
  final List<DpsConsumptionLog> consLogs;
  final List<DpsDamageLog> damLogs;
  final List<ProductEntity> products;
  final List<RawMaterialEntity> rawMaterials;

  DpsRawData({
    required this.filteredReports,
    required this.prodLogs,
    required this.consLogs,
    required this.damLogs,
    required this.products,
    required this.rawMaterials,
  });
}

@riverpod
Future<DpsRawData> dpsRawReportData(Ref ref) async {
  final repo = ref.watch(dpsRepositoryProvider);
  
  // Select ONLY the dates, so changing product checkboxes doesn't trigger a DB refetch!
  final dateRange = ref.watch(dpsSummaryFilterProvider.select((f) => (f.startDate, f.endDate)));
  final startDate = dateRange.$1;
  final endDate = dateRange.$2;

  final products = await ref.watch(getAllProductsProvider.future);
  final rawMaterials = await ref.watch(getAllRawMaterialsProvider.future);

  final allReports = await repo.getReports();
  final filteredReports = allReports.where((r) {
    final date = r.reportDate;
    if (startDate != null) {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      if (date.isBefore(start)) return false;
    }
    if (endDate != null) {
      final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      if (date.isAfter(end)) return false;
    }
    return true;
  }).toList();

  final reportIds = filteredReports.map((r) => r.id!).whereType<int>().toList();

  final prodLogs = reportIds.isNotEmpty ? await repo.getProductionLogsForReportIds(reportIds) : <DpsProductionLog>[];
  final consLogs = reportIds.isNotEmpty ? await repo.getConsumptionLogsForReportIds(reportIds) : <DpsConsumptionLog>[];
  final damLogs = reportIds.isNotEmpty ? await repo.getDamageLogsForReportIds(reportIds) : <DpsDamageLog>[];

  return DpsRawData(
    filteredReports: filteredReports,
    prodLogs: prodLogs,
    consLogs: consLogs,
    damLogs: damLogs,
    products: products,
    rawMaterials: rawMaterials,
  );
}

/// Row structure for Composite Report
class CompositeRow {
  final DateTime date;
  final String dateStr;
  final double? qty;
  final double? weight;
  final double? gasKg;
  final double? woodKg;
  final double? gasPkr;
  final double? woodPkr;

  CompositeRow({
    required this.date,
    required this.dateStr,
    this.qty,
    this.weight,
    this.gasKg,
    this.woodKg,
    this.gasPkr,
    this.woodPkr,
  });
}

/// Row structure for Product-Wise Quantity and Damage Reports
class ProductMatrixRow {
  final DateTime date;
  final String dateStr;
  final Map<int, double?> values;
  final Map<int, String?>? tooltips;

  ProductMatrixRow({
    required this.date,
    required this.dateStr,
    required this.values,
    this.tooltips,
  });
}

/// Complete aggregated matrix report data container
class DpsMatrixReportData {
  final List<CompositeRow> compositeRows;
  final Map<String, double> compositeTotals;
  final List<ProductMatrixRow> quantityRows;
  final Map<int, double> quantityTotals;
  final List<ProductMatrixRow> damageRows;
  final Map<int, double> damageTotals;
  final List<ProductEntity> allProducts;
  final List<RawMaterialEntity> allRawMaterials;

  DpsMatrixReportData({
    required this.compositeRows,
    required this.compositeTotals,
    required this.quantityRows,
    required this.quantityTotals,
    required this.damageRows,
    required this.damageTotals,
    required this.allProducts,
    required this.allRawMaterials,
  });
}

@riverpod
Future<DpsMatrixReportData> dpsSummary(Ref ref) async {
  // Watch the raw data provider. If it's loading, this will naturally await it.
  // Because it only watches the raw data (which only triggers on date changes),
  // toggling UI checkboxes no longer causes this provider to re-fetch raw data!
  final rawData = await ref.watch(dpsRawReportDataProvider.future);
  
  final productMap = {for (final p in rawData.products) p.id: p};
  final rawMaterialMap = {for (final m in rawData.rawMaterials) m.id: m};

  final reportDateById = <int, DateTime>{};
  for (final r in rawData.filteredReports) {
    if (r.id != null) reportDateById[r.id!] = r.reportDate;
  }

  final datesSet = <DateTime>{};
  for (final r in rawData.filteredReports) {
    datesSet.add(DateTime(r.reportDate.year, r.reportDate.month, r.reportDate.day));
  }
  final sortedDates = datesSet.toList()..sort((a, b) => b.compareTo(a));

  final prodByDate = <DateTime, List<DpsProductionLog>>{};
  for (final log in rawData.prodLogs) {
    final reportDate = reportDateById[log.reportId];
    if (reportDate == null) continue;
    final dateKey = DateTime(reportDate.year, reportDate.month, reportDate.day);
    prodByDate.putIfAbsent(dateKey, () => []).add(log);
  }

  final consByDate = <DateTime, List<DpsConsumptionLog>>{};
  for (final log in rawData.consLogs) {
    final reportDate = reportDateById[log.reportId];
    if (reportDate == null) continue;
    final dateKey = DateTime(reportDate.year, reportDate.month, reportDate.day);
    consByDate.putIfAbsent(dateKey, () => []).add(log);
  }

  final damByDate = <DateTime, List<DpsDamageLog>>{};
  for (final log in rawData.damLogs) {
    if (log.itemType != 'product') continue;
    final reportDate = reportDateById[log.reportId];
    if (reportDate == null) continue;
    final dateKey = DateTime(reportDate.year, reportDate.month, reportDate.day);
    damByDate.putIfAbsent(dateKey, () => []).add(log);
  }

  final compositeRows = <CompositeRow>[];
  final compositeTotals = <String, double>{
    'qty': 0.0,
    'weight': 0.0,
    'gas_kg': 0.0,
    'wood_kg': 0.0,
    'gas_pkr': 0.0,
    'wood_pkr': 0.0,
  };

  final quantityRows = <ProductMatrixRow>[];
  final quantityTotals = <int, double>{for (final p in rawData.products) p.id: 0.0};

  final damageRows = <ProductMatrixRow>[];
  final damageTotals = <int, double>{for (final p in rawData.products) p.id: 0.0};

  final dateFormat = DateFormat('dd/MM/yyyy');

  for (final dateKey in sortedDates) {
    final dateStr = dateFormat.format(dateKey);

    // ── 1. Composite Data ──────────────────────────────────────────────────
    final dayProd = prodByDate[dateKey];
    final dayCons = consByDate[dateKey];

    double? totalQty;
    double? totalWeight;

    if (dayProd != null && dayProd.isNotEmpty) {
      double qSum = 0;
      double wSum = 0;
      for (final pLog in dayProd) {
        qSum += pLog.quantity;
        // Use snapshot unitWeight if available, fallback to master product weight
        final weightPerUnit = pLog.unitWeight ?? (productMap[pLog.productId]?.weight ?? 0.0);
        wSum += pLog.quantity * weightPerUnit;
      }
      totalQty = qSum;
      totalWeight = wSum;
      compositeTotals['qty'] = (compositeTotals['qty'] ?? 0.0) + qSum;
      compositeTotals['weight'] = (compositeTotals['weight'] ?? 0.0) + wSum;
    }

    double? gasKg;
    double? gasPkr;
    double? woodKg;
    double? woodPkr;

    if (dayCons != null && dayCons.isNotEmpty) {
      double gKg = 0;
      double gPkr = 0;
      bool hasGas = false;

      double wKg = 0;
      double wPkr = 0;
      bool hasWood = false;

      for (final cLog in dayCons) {
        final mat = rawMaterialMap[cLog.rawMaterialId];
        final name = mat?.name.toLowerCase() ?? '';
        // Use snapshot unitPrice if available, fallback to master material price
        final price = cLog.unitPrice ?? (mat?.price ?? 0.0);

        if (name.contains('gas')) {
          hasGas = true;
          gKg += cLog.quantity;
          gPkr += cLog.quantity * price;
        } else if (name.contains('wood')) {
          hasWood = true;
          wKg += cLog.quantity;
          wPkr += cLog.quantity * price;
        }
      }

      if (hasGas) {
        gasKg = gKg;
        gasPkr = gPkr;
        compositeTotals['gas_kg'] = (compositeTotals['gas_kg'] ?? 0.0) + gKg;
        compositeTotals['gas_pkr'] = (compositeTotals['gas_pkr'] ?? 0.0) + gPkr;
      }

      if (hasWood) {
        woodKg = wKg;
        woodPkr = wPkr;
        compositeTotals['wood_kg'] = (compositeTotals['wood_kg'] ?? 0.0) + wKg;
        compositeTotals['wood_pkr'] = (compositeTotals['wood_pkr'] ?? 0.0) + wPkr;
      }
    }

    compositeRows.add(
      CompositeRow(
        date: dateKey,
        dateStr: dateStr,
        qty: totalQty,
        weight: totalWeight,
        gasKg: gasKg,
        woodKg: woodKg,
        gasPkr: gasPkr,
        woodPkr: woodPkr,
      ),
    );

    // ── 2. Product Quantity Matrix Data ────────────────────────────────────
    final qValues = <int, double?>{};
    if (dayProd != null && dayProd.isNotEmpty) {
      final pSumByProduct = <int, double>{};
      for (final pLog in dayProd) {
        pSumByProduct[pLog.productId] = (pSumByProduct[pLog.productId] ?? 0.0) + pLog.quantity;
      }
      for (final p in rawData.products) {
        if (pSumByProduct.containsKey(p.id)) {
          final val = pSumByProduct[p.id]!;
          qValues[p.id] = val;
          quantityTotals[p.id] = (quantityTotals[p.id] ?? 0.0) + val;
        } else {
          qValues[p.id] = null;
        }
      }
    } else {
      for (final p in rawData.products) {
        qValues[p.id] = null;
      }
    }
    quantityRows.add(ProductMatrixRow(date: dateKey, dateStr: dateStr, values: qValues));

    // ── 3. Product Damage Matrix Data ──────────────────────────────────────
    final dayDam = damByDate[dateKey];
    final dValues = <int, double?>{};
    final dTooltips = <int, String?>{};
    if (dayDam != null && dayDam.isNotEmpty) {
      final dSumByProduct = <int, double>{};
      final dReasonsByProduct = <int, List<String>>{};
      for (final dLog in dayDam) {
        dSumByProduct[dLog.itemId] = (dSumByProduct[dLog.itemId] ?? 0.0) + dLog.quantity;
        if (dLog.reason != null && dLog.reason!.trim().isNotEmpty) {
          dReasonsByProduct.putIfAbsent(dLog.itemId, () => []).add(dLog.reason!.trim());
        }
      }
      for (final p in rawData.products) {
        if (dSumByProduct.containsKey(p.id)) {
          final val = dSumByProduct[p.id]!;
          dValues[p.id] = val;
          damageTotals[p.id] = (damageTotals[p.id] ?? 0.0) + val;
          if (dReasonsByProduct.containsKey(p.id)) {
            dTooltips[p.id] = dReasonsByProduct[p.id]!.join(' | ');
          } else {
            dTooltips[p.id] = null;
          }
        } else {
          dValues[p.id] = null;
          dTooltips[p.id] = null;
        }
      }
    } else {
      for (final p in rawData.products) {
        dValues[p.id] = null;
        dTooltips[p.id] = null;
      }
    }
    damageRows.add(ProductMatrixRow(date: dateKey, dateStr: dateStr, values: dValues, tooltips: dTooltips));
  }

  return DpsMatrixReportData(
    compositeRows: compositeRows,
    compositeTotals: compositeTotals,
    quantityRows: quantityRows,
    quantityTotals: quantityTotals,
    damageRows: damageRows,
    damageTotals: damageTotals,
    allProducts: rawData.products,
    allRawMaterials: rawData.rawMaterials,
  );
}
