import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/dps_models.dart';
import '../providers/dps_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../raw_material/presentation/providers/raw_material_providers.dart';

final dpsReportDetailsProvider =
    FutureProvider.family<_DpsReportDetailsData, int>((ref, reportId) async {
      final repository = ref.watch(dpsRepositoryProvider);

      final energyLogs = await repository.getEnergyLogsForReport(reportId);
      final productionLogs = await repository.getProductionLogsForReport(
        reportId,
      );
      final consumptionLogs = await repository.getConsumptionLogsForReport(
        reportId,
      );
      final damageLogs = await repository.getDamageLogsForReport(reportId);

      return _DpsReportDetailsData(
        energyLogs: energyLogs,
        productionLogs: productionLogs,
        consumptionLogs: consumptionLogs,
        damageLogs: damageLogs,
      );
    });

class DpsReportDetailsPage extends ConsumerWidget {
  final DpsReport report;

  const DpsReportDetailsPage({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportId = report.id;

    if (reportId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('DPS Report Details')),
        body: const Center(child: Text('Invalid report id')),
      );
    }

    final detailsAsync = ref.watch(dpsReportDetailsProvider(reportId));
    final machinesAsync = ref.watch(dpsMachinesProvider);
    final productsAsync = ref.watch(getAllProductsProvider);
    final rawMaterialsAsync = ref.watch(getAllRawMaterialsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('DPS Report Details')),
      body: detailsAsync.when(
        data: (details) {
          return machinesAsync.when(
            data: (machines) {
              return productsAsync.when(
                data: (products) {
                  return rawMaterialsAsync.when(
                    data: (materials) {
                      final productNames = {
                        for (final p in products) p.id: p.name,
                      };
                      final materialNames = {
                        for (final m in materials) m.id: m.name,
                      };

                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ListTile(
                            title: const Text('Report Date'),
                            subtitle: Text(
                              DateFormat(
                                'yyyy-MM-dd',
                              ).format(report.reportDate),
                            ),
                            trailing: const Icon(Icons.calendar_today),
                          ),
                          if (report.notes != null &&
                              report.notes!.trim().isNotEmpty)
                            ListTile(
                              title: const Text('Notes'),
                              subtitle: Text(report.notes!.trim()),
                            ),
                          ListTile(
                            title: const Text('Status'),
                            subtitle: Text(report.status),
                          ),
                          const Divider(),

                          const _SectionHeader(title: 'Energy Logging'),
                          ...machines.map(
                            (machine) => _EnergyDetailsCard(
                              machine: machine,
                              log: details.energyByMachine[machine.id],
                            ),
                          ),

                          const Divider(),

                          const _SectionHeader(title: 'Production Logging'),
                          ...machines.map(
                            (machine) => _ProductionDetailsCard(
                              machine: machine,
                              logs:
                                  details.productionByMachine[machine.id] ??
                                  const [],
                              productNames: productNames,
                            ),
                          ),

                          const Divider(),

                          const _SectionHeader(title: 'Consumption Logging'),
                          ...machines.map(
                            (machine) => _ConsumptionDetailsCard(
                              machine: machine,
                              logs:
                                  details.consumptionByMachine[machine.id] ??
                                  const [],
                              materialNames: materialNames,
                            ),
                          ),

                          const Divider(),

                          const _SectionHeader(title: 'Damage Logging'),
                          ...machines.map(
                            (machine) => _DamageDetailsCard(
                              machine: machine,
                              logs:
                                  details.damageByMachine[machine.id] ??
                                  const [],
                              productNames: productNames,
                              materialNames: materialNames,
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _DpsReportDetailsData {
  final List<DpsEnergyLog> energyLogs;
  final List<DpsProductionLog> productionLogs;
  final List<DpsConsumptionLog> consumptionLogs;
  final List<DpsDamageLog> damageLogs;

  const _DpsReportDetailsData({
    required this.energyLogs,
    required this.productionLogs,
    required this.consumptionLogs,
    required this.damageLogs,
  });

  Map<int, DpsEnergyLog> get energyByMachine {
    return {for (final log in energyLogs) log.machineId: log};
  }

  Map<int, List<DpsProductionLog>> get productionByMachine {
    final grouped = <int, List<DpsProductionLog>>{};
    for (final log in productionLogs) {
      grouped.putIfAbsent(log.machineId, () => []).add(log);
    }
    return grouped;
  }

  Map<int, List<DpsConsumptionLog>> get consumptionByMachine {
    final grouped = <int, List<DpsConsumptionLog>>{};
    for (final log in consumptionLogs) {
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _EnergyDetailsCard extends StatelessWidget {
  final Machine machine;
  final DpsEnergyLog? log;

  const _EnergyDetailsCard({required this.machine, required this.log});

  @override
  Widget build(BuildContext context) {
    final currentLog = log ?? DpsEnergyLog(machineId: machine.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(machine.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: currentLog.operatorName ?? '',
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Operator Name'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: currentLog.gasWeight.toString(),
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Gas Weight'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: currentLog.woodWeight.toString(),
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Wood Weight'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductionDetailsCard extends StatelessWidget {
  final Machine machine;
  final List<DpsProductionLog> logs;
  final Map<int, String> productNames;

  const _ProductionDetailsCard({
    required this.machine,
    required this.logs,
    required this.productNames,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(machine.name, style: Theme.of(context).textTheme.titleMedium),
            if (logs.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('No production entries'),
              )
            else
              ...logs.map((log) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue:
                              productNames[log.productId] ?? 'Unknown Product',
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Product',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: log.quantity.toString(),
                          readOnly: true,
                          decoration: const InputDecoration(labelText: 'Qty'),
                        ),
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

class _ConsumptionDetailsCard extends StatelessWidget {
  final Machine machine;
  final List<DpsConsumptionLog> logs;
  final Map<int, String> materialNames;

  const _ConsumptionDetailsCard({
    required this.machine,
    required this.logs,
    required this.materialNames,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(machine.name, style: Theme.of(context).textTheme.titleMedium),
            if (logs.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('No consumption entries'),
              )
            else
              ...logs.map((log) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue:
                              materialNames[log.rawMaterialId] ??
                              'Unknown Raw Material',
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Raw Material',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: log.quantity.toString(),
                          readOnly: true,
                          decoration: const InputDecoration(labelText: 'Qty'),
                        ),
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

class _DamageDetailsCard extends StatelessWidget {
  final Machine machine;
  final List<DpsDamageLog> logs;
  final Map<int, String> productNames;
  final Map<int, String> materialNames;

  const _DamageDetailsCard({
    required this.machine,
    required this.logs,
    required this.productNames,
    required this.materialNames,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(machine.name, style: Theme.of(context).textTheme.titleMedium),
            if (logs.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('No damage entries'),
              )
            else
              ...logs.map((log) {
                final itemName = log.itemType == 'product'
                    ? (productNames[log.itemId] ?? 'Unknown Product')
                    : (materialNames[log.itemId] ?? 'Unknown Raw Material');

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: log.itemType == 'product'
                                  ? 'Product'
                                  : 'Raw Material',
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Item Type',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: itemName,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: log.itemType == 'product'
                                    ? 'Product'
                                    : 'Raw Material',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: log.quantity.toString(),
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Qty',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: log.reason ?? '',
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Reason',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
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
