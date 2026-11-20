import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/dps_models.dart';
import '../../domain/repositories/dps_repository.dart';
import '../../data/datasources/dps_remote_datasource.dart';
import '../../data/repositories/dps_repository.dart' as impl;
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../raw_material/domain/entities/raw_material_entity.dart';
import '../../../raw_material/presentation/providers/raw_material_providers.dart';

part 'dps_providers.g.dart';

@riverpod
DpsRepository dpsRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final remote = DpsRemoteDataSource(client);
  return impl.DpsRepositoryImpl(remote);
}

@riverpod
Future<List<Machine>> dpsMachines(Ref ref) async {
  return ref.watch(dpsRepositoryProvider).getMachines();
}

@riverpod
Future<List<DpsReport>> dpsReports(Ref ref) async {
  return ref.watch(dpsRepositoryProvider).getReports();
}

class DpsFormState {
  final DateTime selectedDate;
  final List<DpsConsumptionLog> consumptionLogs;
  final Map<int, List<DpsProductionLog>> productionLogs;
  final Map<int, List<DpsDamageLog>> damageLogs;

  DpsFormState({
    required this.selectedDate,
    this.consumptionLogs = const [],
    this.productionLogs = const {},
    this.damageLogs = const {},
  });

  DpsFormState copyWith({
    DateTime? selectedDate,
    List<DpsConsumptionLog>? consumptionLogs,
    Map<int, List<DpsProductionLog>>? productionLogs,
    Map<int, List<DpsDamageLog>>? damageLogs,
  }) {
    return DpsFormState(
      selectedDate: selectedDate ?? this.selectedDate,
      consumptionLogs: consumptionLogs ?? this.consumptionLogs,
      productionLogs: productionLogs ?? this.productionLogs,
      damageLogs: damageLogs ?? this.damageLogs,
    );
  }
}

@riverpod
class DpsFormNotifier extends _$DpsFormNotifier {
  @override
  DpsFormState build() {
    return DpsFormState(selectedDate: DateTime.now());
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void addProductionLog(int machineId, DpsProductionLog log) {
    final logs = Map<int, List<DpsProductionLog>>.from(state.productionLogs);
    logs[machineId] = [...(logs[machineId] ?? []), log];
    state = state.copyWith(productionLogs: logs);
  }

  void updateProductionLog(int machineId, int index, DpsProductionLog log) {
    final logs = Map<int, List<DpsProductionLog>>.from(state.productionLogs);
    if (logs.containsKey(machineId)) {
      final list = List<DpsProductionLog>.from(logs[machineId]!);
      list[index] = log;
      logs[machineId] = list;
      state = state.copyWith(productionLogs: logs);
    }
  }

  void removeProductionLog(int machineId, int index) {
    final logs = Map<int, List<DpsProductionLog>>.from(state.productionLogs);
    if (logs.containsKey(machineId)) {
      final list = List<DpsProductionLog>.from(logs[machineId]!);
      list.removeAt(index);
      logs[machineId] = list;
      state = state.copyWith(productionLogs: logs);
    }
  }

  void addConsumptionLog(DpsConsumptionLog log) {
    state = state.copyWith(consumptionLogs: [...state.consumptionLogs, log]);
  }

  void updateConsumptionLog(int index, DpsConsumptionLog log) {
    final list = List<DpsConsumptionLog>.from(state.consumptionLogs);
    list[index] = log;
    state = state.copyWith(consumptionLogs: list);
  }

  void removeConsumptionLog(int index) {
    final list = List<DpsConsumptionLog>.from(state.consumptionLogs);
    list.removeAt(index);
    state = state.copyWith(consumptionLogs: list);
  }

  void addDamageLog(int machineId, DpsDamageLog log) {
    final logs = Map<int, List<DpsDamageLog>>.from(state.damageLogs);
    logs[machineId] = [...(logs[machineId] ?? []), log];
    state = state.copyWith(damageLogs: logs);
  }

  void updateDamageLog(int machineId, int index, DpsDamageLog log) {
    final logs = Map<int, List<DpsDamageLog>>.from(state.damageLogs);
    if (logs.containsKey(machineId)) {
      final list = List<DpsDamageLog>.from(logs[machineId]!);
      list[index] = log;
      logs[machineId] = list;
      state = state.copyWith(damageLogs: logs);
    }
  }

  void removeDamageLog(int machineId, int index) {
    final logs = Map<int, List<DpsDamageLog>>.from(state.damageLogs);
    if (logs.containsKey(machineId)) {
      final list = List<DpsDamageLog>.from(logs[machineId]!);
      list.removeAt(index);
      logs[machineId] = list;
      state = state.copyWith(damageLogs: logs);
    }
  }

  /// Submits the DPS report.
  /// Returns `null` on success, or a human-readable error message on failure.
  Future<String?> submit() async {
    try {
      // 1. Fetch machines, products, and raw materials for labels and snapshot values
      final machines = await ref.read(dpsMachinesProvider.future).catchError((_) => <Machine>[]);
      final machineMap = {for (final m in machines) m.id: m.name};

      final products = await ref.read(getAllProductsProvider.future).catchError((_) => <ProductEntity>[]);
      final productMap = {for (final p in products) p.id: p};

      final materials = await ref.read(getAllRawMaterialsProvider.future).catchError((_) => <RawMaterialEntity>[]);
      final materialMap = {for (final m in materials) m.id: m};

      // 2. Validate and clean Consumption Logs
      final validConsLogs = <DpsConsumptionLog>[];
      for (int i = 0; i < state.consumptionLogs.length; i++) {
        final log = state.consumptionLogs[i];
        final isUntouched = log.rawMaterialId == -1 && log.quantity <= 0;
        if (isUntouched) {
          // Auto-ignore untouched ghost rows added accidentally
          continue;
        }

        if (log.rawMaterialId == -1 && log.quantity > 0) {
          return 'Raw Material row #${i + 1}: Please select a material for quantity ${log.quantity}.';
        }

        if (log.rawMaterialId != -1 && log.quantity <= 0) {
          final matName = materialMap[log.rawMaterialId]?.name ?? 'Item';
          return 'Raw Material "$matName": Quantity must be greater than 0.';
        }

        // Attach snapshot unit_price if available
        final price = materialMap[log.rawMaterialId]?.price;
        validConsLogs.add(log.copyWith(unitPrice: log.unitPrice ?? price));
      }

      // 3. Validate and clean Production Logs
      final validProdLogs = <DpsProductionLog>[];
      for (final entry in state.productionLogs.entries) {
        final machineId = entry.key;
        final machineName = machineMap[machineId] ?? 'Machine';
        final logs = entry.value;

        for (int i = 0; i < logs.length; i++) {
          final log = logs[i];
          final isUntouched = log.productId == -1 && log.quantity <= 0;
          if (isUntouched) {
            // Auto-ignore untouched ghost rows
            continue;
          }

          if (log.productId == -1 && log.quantity > 0) {
            return '$machineName (Production): Please select a product for row #${i + 1}.';
          }

          if (log.productId != -1 && log.quantity <= 0) {
            final prodName = productMap[log.productId]?.name ?? 'Product';
            return '$machineName (Production): Quantity for "$prodName" must be greater than 0.';
          }

          // Attach snapshot unit_weight if available
          final weight = productMap[log.productId]?.weight;
          validProdLogs.add(log.copyWith(unitWeight: log.unitWeight ?? weight));
        }
      }

      // 4. Validate and clean Damage Logs
      final validDamLogs = <DpsDamageLog>[];
      for (final entry in state.damageLogs.entries) {
        final machineId = entry.key;
        final machineName = machineMap[machineId] ?? 'Machine';
        final logs = entry.value;

        for (int i = 0; i < logs.length; i++) {
          final log = logs[i];
          final isUntouched = log.itemId == -1 && log.quantity <= 0;
          if (isUntouched) {
            // Auto-ignore untouched ghost rows
            continue;
          }

          if (log.itemId == -1 && log.quantity > 0) {
            return '$machineName (Damage): Please select a product for row #${i + 1}.';
          }

          if (log.itemId != -1 && log.quantity <= 0) {
            final prodName = productMap[log.itemId]?.name ?? 'Product';
            return '$machineName (Damage): Quantity for "$prodName" must be greater than 0.';
          }

          final weight = productMap[log.itemId]?.weight;
          validDamLogs.add(log.copyWith(unitWeight: log.unitWeight ?? weight));
        }
      }

      // 5. Ensure at least one valid log exists
      if (validProdLogs.isEmpty &&
          validConsLogs.isEmpty &&
          validDamLogs.isEmpty) {
        return 'Report is empty. Please enter at least one production, consumption, or damage entry with a quantity > 0.';
      }

      // 6. Submit to Supabase
      await ref
          .read(dpsRepositoryProvider)
          .createReport(
            reportDate: state.selectedDate,
            productionLogs: validProdLogs,
            consumptionLogs: validConsLogs,
            damageLogs: validDamLogs,
          );

      ref.invalidate(dpsReportsProvider);
      return null; // Success!
    } catch (e) {
      return 'Failed to save report: $e';
    }
  }
}
