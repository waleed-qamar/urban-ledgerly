import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/features/employee/presentation/provider/employee_providers.dart';
import '../../domain/entities/dps_models.dart';
import '../providers/dps_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../raw_material/presentation/providers/raw_material_providers.dart';

class AddDpsReportPage extends ConsumerStatefulWidget {
  const AddDpsReportPage({super.key});

  @override
  ConsumerState<AddDpsReportPage> createState() => _AddDpsReportPageState();
}

class _AddDpsReportPageState extends ConsumerState<AddDpsReportPage> {
  @override
  Widget build(BuildContext context) {
    final machinesAsyncValue = ref.watch(dpsMachinesProvider);
    final employeeAsyncValue = ref.watch(getAllEmployeesProvider);
    final formState = ref.watch(dpsFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New DPS Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final success = await ref.read(dpsFormProvider.notifier).submit();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report saved successfully')),
                );
                Navigator.pop(context, true);
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to save or empty report'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: machinesAsyncValue.when(
        data: (machines) {
          if (machines.isEmpty) {
            return const Center(
              child: Text('No machines found. Please add machines first.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Date Selection
              ListTile(
                title: const Text('Report Date'),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd').format(formState.selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: formState.selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    ref.read(dpsFormProvider.notifier).setDate(date);
                  }
                },
              ),
              const Divider(),

              // Energy Section
              const _SectionHeader(title: 'Energy Logging'),
              ...machines.map((machine) => _EnergyFormCard(machine: machine)),

              const Divider(),

              // Production Section
              const _SectionHeader(title: 'Production Logging'),
              ...machines.map(
                (machine) => _ProductionFormCard(machine: machine),
              ),

              const Divider(),

              // Consumption Section
              const _SectionHeader(title: 'Consumption Logging'),
              ...machines.map(
                (machine) => _ConsumptionFormCard(machine: machine),
              ),

              const Divider(),

              // Damage Section
              const _SectionHeader(title: 'Damage Logging'),
              ...machines.map((machine) => _DamageFormCard(machine: machine)),

              const SizedBox(height: 80),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
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

class _EnergyFormCard extends ConsumerWidget {
  final Machine machine;
  const _EnergyFormCard({required this.machine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsyncValue = ref.watch(getAllEmployeesProvider);
    final formState = ref.watch(dpsFormProvider);
    final log =
        formState.energyLogs[machine.id] ?? DpsEnergyLog(machineId: machine.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(machine.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            employeeAsyncValue.when(
              data: (employees) {
                if (employees.isEmpty) {
                  return const Text('No employees available');
                }
                // Use first employee if operatorName is empty or not found in list
                final validInitialValue =
                    (log.operatorName != null &&
                        log.operatorName!.isNotEmpty &&
                        employees.any((e) => e.name == log.operatorName))
                    ? log.operatorName
                    : null;
                return DropdownButtonFormField<String?>(
                  initialValue: validInitialValue,
                  hint: const Text('Select Operator'),
                  decoration: const InputDecoration(labelText: 'Operator'),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Select Operator'),
                    ),
                    ...employees.map(
                      (e) => DropdownMenuItem<String?>(
                        value: e.name,
                        child: Text(e.name),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(dpsFormProvider.notifier)
                          .updateEnergyLog(
                            machine.id,
                            log.copyWith(operatorName: val),
                          );
                    }
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) =>
                  const Text('Error loading employees'),
            ),
            // TextFormField(
            //   initialValue: log.operatorName,
            //   decoration: const InputDecoration(labelText: 'Operator Name'),
            //   onChanged: (val) {
            //     ref
            //         .read(dpsFormProvider.notifier)
            //         .updateEnergyLog(
            //           machine.id,
            //           log.copyWith(operatorName: val),
            //         );
            //   },
            // ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: log.gasWeight.toString(),
                    decoration: const InputDecoration(labelText: 'Gas Weight'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final parsed = double.tryParse(val) ?? 0.0;
                      ref
                          .read(dpsFormProvider.notifier)
                          .updateEnergyLog(
                            machine.id,
                            log.copyWith(gasWeight: parsed),
                          );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: log.woodWeight.toString(),
                    decoration: const InputDecoration(labelText: 'Wood Weight'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final parsed = double.tryParse(val) ?? 0.0;
                      ref
                          .read(dpsFormProvider.notifier)
                          .updateEnergyLog(
                            machine.id,
                            log.copyWith(woodWeight: parsed),
                          );
                    },
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

class _ProductionFormCard extends ConsumerWidget {
  final Machine machine;
  const _ProductionFormCard({required this.machine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(dpsFormProvider);
    final logs = formState.productionLogs[machine.id] ?? [];
    final productsAsync = ref.watch(getAllProductsProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  machine.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: productsAsync.when(
                    data: (products) => products.isEmpty
                        ? null
                        : () {
                            ref
                                .read(dpsFormProvider.notifier)
                                .addProductionLog(
                                  machine.id,
                                  DpsProductionLog(
                                    machineId: machine.id,
                                    productId: products.first.id,
                                    quantity: 1.0,
                                  ),
                                );
                          },
                    loading: () => null,
                    error: (error, stackTrace) => null,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ],
            ),
            ...logs.asMap().entries.map((entry) {
              final index = entry.key;
              final log = entry.value;

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: productsAsync.when(
                        data: (products) => DropdownButtonFormField<int>(
                          initialValue: log.productId,
                          decoration: const InputDecoration(
                            labelText: 'Product',
                          ),
                          items: products
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p.id,
                                  child: Text(p.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              ref
                                  .read(dpsFormProvider.notifier)
                                  .updateProductionLog(
                                    machine.id,
                                    index,
                                    log.copyWith(productId: val),
                                  );
                            }
                          },
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) => const Text('Error'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: log.quantity.toString(),
                        decoration: const InputDecoration(labelText: 'Qty'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final parsed = double.tryParse(val) ?? 0.0;
                          ref
                              .read(dpsFormProvider.notifier)
                              .updateProductionLog(
                                machine.id,
                                index,
                                log.copyWith(quantity: parsed),
                              );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ref
                            .read(dpsFormProvider.notifier)
                            .removeProductionLog(machine.id, index);
                      },
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

class _ConsumptionFormCard extends ConsumerWidget {
  final Machine machine;
  const _ConsumptionFormCard({required this.machine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(dpsFormProvider);
    final logs = formState.consumptionLogs[machine.id] ?? [];
    final rawMaterialsAsync = ref.watch(getAllRawMaterialsProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  machine.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: rawMaterialsAsync.when(
                    data: (materials) => materials.isEmpty
                        ? null
                        : () {
                            ref
                                .read(dpsFormProvider.notifier)
                                .addConsumptionLog(
                                  machine.id,
                                  DpsConsumptionLog(
                                    machineId: machine.id,
                                    rawMaterialId: materials.first.id,
                                    quantity: 1.0,
                                  ),
                                );
                          },
                    loading: () => null,
                    error: (error, stackTrace) => null,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Raw Material'),
                ),
              ],
            ),
            ...logs.asMap().entries.map((entry) {
              final index = entry.key;
              final log = entry.value;

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: rawMaterialsAsync.when(
                        data: (materials) => DropdownButtonFormField<int>(
                          initialValue: log.rawMaterialId,
                          decoration: const InputDecoration(
                            labelText: 'Raw Material',
                          ),
                          items: materials
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m.id,
                                  child: Text(m.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              ref
                                  .read(dpsFormProvider.notifier)
                                  .updateConsumptionLog(
                                    machine.id,
                                    index,
                                    log.copyWith(rawMaterialId: val),
                                  );
                            }
                          },
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) => const Text('Error'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: log.quantity.toString(),
                        decoration: const InputDecoration(labelText: 'Qty'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final parsed = double.tryParse(val) ?? 0.0;
                          ref
                              .read(dpsFormProvider.notifier)
                              .updateConsumptionLog(
                                machine.id,
                                index,
                                log.copyWith(quantity: parsed),
                              );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ref
                            .read(dpsFormProvider.notifier)
                            .removeConsumptionLog(machine.id, index);
                      },
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

class _DamageFormCard extends ConsumerWidget {
  final Machine machine;
  const _DamageFormCard({required this.machine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(dpsFormProvider);
    final logs = formState.damageLogs[machine.id] ?? [];

    final productsAsync = ref.watch(getAllProductsProvider);
    final rawMaterialsAsync = ref.watch(getAllRawMaterialsProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  machine.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () {
                    // Default to product if products exist, otherwise try raw material
                    productsAsync.whenData((products) {
                      if (products.isNotEmpty) {
                        ref
                            .read(dpsFormProvider.notifier)
                            .addDamageLog(
                              machine.id,
                              DpsDamageLog(
                                machineId: machine.id,
                                itemType: 'product',
                                itemId: products.first.id,
                                quantity: 1.0,
                              ),
                            );
                      } else {
                        rawMaterialsAsync.whenData((materials) {
                          if (materials.isNotEmpty) {
                            ref
                                .read(dpsFormProvider.notifier)
                                .addDamageLog(
                                  machine.id,
                                  DpsDamageLog(
                                    machineId: machine.id,
                                    itemType: 'raw_material',
                                    itemId: materials.first.id,
                                    quantity: 1.0,
                                  ),
                                );
                          }
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Damage'),
                ),
              ],
            ),
            ...logs.asMap().entries.map((entry) {
              final index = entry.key;
              final log = entry.value;

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: log.itemType,
                            decoration: const InputDecoration(
                              labelText: 'Item Type',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'product',
                                child: Text('Product'),
                              ),
                              DropdownMenuItem(
                                value: 'raw_material',
                                child: Text('Raw Material'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                // We should reset the itemId when type changes to avoid invalid IDs
                                int newItemId = 0;
                                if (val == 'product') {
                                  productsAsync.whenData((list) {
                                    if (list.isNotEmpty)
                                      newItemId = list.first.id;
                                  });
                                } else {
                                  rawMaterialsAsync.whenData((list) {
                                    if (list.isNotEmpty)
                                      newItemId = list.first.id;
                                  });
                                }

                                ref
                                    .read(dpsFormProvider.notifier)
                                    .updateDamageLog(
                                      machine.id,
                                      index,
                                      log.copyWith(
                                        itemType: val,
                                        itemId: newItemId,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Builder(
                            builder: (context) {
                              if (log.itemType == 'product') {
                                return productsAsync.when(
                                  data: (products) =>
                                      DropdownButtonFormField<int>(
                                        value:
                                            products.any(
                                              (p) => p.id == log.itemId,
                                            )
                                            ? log.itemId
                                            : (products.isNotEmpty
                                                  ? products.first.id
                                                  : null),
                                        decoration: const InputDecoration(
                                          labelText: 'Product',
                                        ),
                                        items: products
                                            .map(
                                              (p) => DropdownMenuItem(
                                                value: p.id,
                                                child: Text(p.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            ref
                                                .read(dpsFormProvider.notifier)
                                                .updateDamageLog(
                                                  machine.id,
                                                  index,
                                                  log.copyWith(itemId: val),
                                                );
                                          }
                                        },
                                      ),
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                  error: (error, stackTrace) =>
                                      const Text('Error'),
                                );
                              } else {
                                return rawMaterialsAsync.when(
                                  data: (materials) =>
                                      DropdownButtonFormField<int>(
                                        value:
                                            materials.any(
                                              (m) => m.id == log.itemId,
                                            )
                                            ? log.itemId
                                            : (materials.isNotEmpty
                                                  ? materials.first.id
                                                  : null),
                                        decoration: const InputDecoration(
                                          labelText: 'Raw Material',
                                        ),
                                        items: materials
                                            .map(
                                              (m) => DropdownMenuItem(
                                                value: m.id,
                                                child: Text(m.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            ref
                                                .read(dpsFormProvider.notifier)
                                                .updateDamageLog(
                                                  machine.id,
                                                  index,
                                                  log.copyWith(itemId: val),
                                                );
                                          }
                                        },
                                      ),
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                  error: (error, stackTrace) =>
                                      const Text('Error'),
                                );
                              }
                            },
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
                            decoration: const InputDecoration(labelText: 'Qty'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              final parsed = double.tryParse(val) ?? 0.0;
                              ref
                                  .read(dpsFormProvider.notifier)
                                  .updateDamageLog(
                                    machine.id,
                                    index,
                                    log.copyWith(quantity: parsed),
                                  );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: log.reason,
                            decoration: const InputDecoration(
                              labelText: 'Reason',
                            ),
                            onChanged: (val) {
                              ref
                                  .read(dpsFormProvider.notifier)
                                  .updateDamageLog(
                                    machine.id,
                                    index,
                                    log.copyWith(reason: val),
                                  );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref
                                .read(dpsFormProvider.notifier)
                                .removeDamageLog(machine.id, index);
                          },
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
