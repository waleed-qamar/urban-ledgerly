import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/dps_models.dart';
import '../../domain/repositories/dps_repository.dart';
import '../../data/datasources/dps_remote_datasource.dart';
import '../../data/repositories/dps_repository.dart' as impl;

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
  final Map<int, DpsEnergyLog> energyLogs;
  final Map<int, List<DpsProductionLog>> productionLogs;
  final Map<int, List<DpsConsumptionLog>> consumptionLogs;
  final Map<int, List<DpsDamageLog>> damageLogs;

  DpsFormState({
    required this.selectedDate,
    this.energyLogs = const {},
    this.productionLogs = const {},
    this.consumptionLogs = const {},
    this.damageLogs = const {},
  });

  DpsFormState copyWith({
    DateTime? selectedDate,
    Map<int, DpsEnergyLog>? energyLogs,
    Map<int, List<DpsProductionLog>>? productionLogs,
    Map<int, List<DpsConsumptionLog>>? consumptionLogs,
    Map<int, List<DpsDamageLog>>? damageLogs,
  }) {
    return DpsFormState(
      selectedDate: selectedDate ?? this.selectedDate,
      energyLogs: energyLogs ?? this.energyLogs,
      productionLogs: productionLogs ?? this.productionLogs,
      consumptionLogs: consumptionLogs ?? this.consumptionLogs,
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

  void updateEnergyLog(int machineId, DpsEnergyLog log) {
    final logs = Map<int, DpsEnergyLog>.from(state.energyLogs);
    logs[machineId] = log;
    state = state.copyWith(energyLogs: logs);
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

  void addConsumptionLog(int machineId, DpsConsumptionLog log) {
    final logs = Map<int, List<DpsConsumptionLog>>.from(state.consumptionLogs);
    logs[machineId] = [...(logs[machineId] ?? []), log];
    state = state.copyWith(consumptionLogs: logs);
  }

  void updateConsumptionLog(int machineId, int index, DpsConsumptionLog log) {
    final logs = Map<int, List<DpsConsumptionLog>>.from(state.consumptionLogs);
    if (logs.containsKey(machineId)) {
      final list = List<DpsConsumptionLog>.from(logs[machineId]!);
      list[index] = log;
      logs[machineId] = list;
      state = state.copyWith(consumptionLogs: logs);
    }
  }

  void removeConsumptionLog(int machineId, int index) {
    final logs = Map<int, List<DpsConsumptionLog>>.from(state.consumptionLogs);
    if (logs.containsKey(machineId)) {
      final list = List<DpsConsumptionLog>.from(logs[machineId]!);
      list.removeAt(index);
      logs[machineId] = list;
      state = state.copyWith(consumptionLogs: logs);
    }
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

  Future<bool> submit() async {
    try {
      final allEnergyLogs = state.energyLogs.values.toList();
      final allProdLogs = state.productionLogs.values.expand((e) => e).toList();
      final allConsLogs = state.consumptionLogs.values
          .expand((e) => e)
          .toList();
      final allDamLogs = state.damageLogs.values.expand((e) => e).toList();

      if (allEnergyLogs.isEmpty &&
          allProdLogs.isEmpty &&
          allConsLogs.isEmpty &&
          allDamLogs.isEmpty) {
        return false; // Prevent empty submission
      }

      await ref
          .read(dpsRepositoryProvider)
          .createReport(
            reportDate: state.selectedDate,
            energyLogs: allEnergyLogs,
            productionLogs: allProdLogs,
            consumptionLogs: allConsLogs,
            damageLogs: allDamLogs,
          );

      ref.invalidate(dpsReportsProvider);
      return true;
    } catch (e) {
      return false;
    }
  }
}
