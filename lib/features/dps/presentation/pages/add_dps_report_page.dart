import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/dps_models.dart';
import '../providers/dps_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../../raw_material/presentation/providers/raw_material_providers.dart';
import '../../../../core/theme/app_colors.dart';

class AddDpsReportPage extends ConsumerStatefulWidget {
  const AddDpsReportPage({super.key});

  @override
  ConsumerState<AddDpsReportPage> createState() => _AddDpsReportPageState();
}

class _AddDpsReportPageState extends ConsumerState<AddDpsReportPage> {
  bool _isSubmitting = false;

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return; // guard against double taps

    setState(() => _isSubmitting = true);

    final success = await ref.read(dpsFormProvider.notifier).submit();

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Report saved successfully'),
            ],
          ),
          backgroundColor: AppColors.successText,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Failed to save — report may be empty')),
            ],
          ),
          backgroundColor: AppColors.errorBackground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final machinesAsyncValue = ref.watch(dpsMachinesProvider);
    final formState = ref.watch(dpsFormProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(title: const Text('New DPS Report')),
      bottomNavigationBar: _SaveButtonBar(
        isSubmitting: _isSubmitting,
        onPressed: _handleSubmit,
      ),
      body: machinesAsyncValue.when(
        data: (machines) {
          if (machines.isEmpty) {
            return Center(
              child: Text(
                'No machines found. Please add machines first.',
                style: TextStyle(color: AppColors.textGrey),
              ),
            );
          }

          // Keep machines ordered 1st -> last
          final sortedMachines = [...machines]
            ..sort((a, b) => a.id.compareTo(b.id));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Date Selection
              Card(
                elevation: 0,
                color: AppColors.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.dividerColor),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: const Text(
                    'Report Date',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(formState.selectedDate),
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                  trailing: Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                  ),
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
              ),
              const SizedBox(height: 20),

              // Cumulative Raw Material Consumption Section
              const _SectionHeader(title: 'Total Raw Material Consumption'),
              const _CumulativeConsumptionFormCard(),
              const SizedBox(height: 8),
              Divider(color: AppColors.dividerColor, thickness: 1),

              // Machine Specific Section (Production & Damage) — responsive grid
              const _SectionHeader(title: 'Machine Production & Damage'),
              _MachineGrid(machines: sortedMachines),

              const SizedBox(height: 80),
            ],
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, st) => Center(
          child: Text(
            'Error: $e',
            style: TextStyle(color: AppColors.errorText),
          ),
        ),
      ),
    );
  }
}

/// Full-width save action pinned to the bottom of the screen. This is far
/// more discoverable than a small AppBar icon — especially on a long,
/// scrollable form — and it gives clear loading / disabled feedback so a
/// user can't fire off duplicate submissions.
class _SaveButtonBar extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _SaveButtonBar({required this.isSubmitting, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: FilledButton(
            onPressed: isSubmitting ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isSubmitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textWhite,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Saving...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle_outline, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Save Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Lays machine cards out in a responsive grid (2-3 columns depending on
/// available width) while letting each card size itself naturally, since
/// the number of production/damage rows per machine varies.
class _MachineGrid extends StatelessWidget {
  final List<Machine> machines;
  const _MachineGrid({required this.machines});

  @override
  Widget build(BuildContext context) {
    const spacing = 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columns;
        if (width >= 1100) {
          columns = 3;
        } else if (width >= 700) {
          columns = 2;
        } else {
          columns = 1;
        }

        final cardWidth = (width - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: machines.asMap().entries.map((entry) {
            final order = entry.key + 1; // 1st, 2nd, 3rd...
            final machine = entry.value;
            return SizedBox(
              width: columns == 1 ? width : cardWidth,
              child: _MachineActivityCard(machine: machine, order: order),
            );
          }).toList(),
        );
      },
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
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
      ),
    );
  }
}

class _CumulativeConsumptionFormCard extends ConsumerWidget {
  const _CumulativeConsumptionFormCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(dpsFormProvider);
    final logs = formState.consumptionLogs;
    final rawMaterialsAsync = ref.watch(getAllRawMaterialsProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: AppColors.textWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                onPressed: rawMaterialsAsync.when(
                  data: (materials) => materials.isEmpty
                      ? null
                      : () {
                          ref
                              .read(dpsFormProvider.notifier)
                              .addConsumptionLog(
                                DpsConsumptionLog(
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
                        data: (materials) {
                          return DropdownButtonFormField<int>(
                            initialValue: log.rawMaterialId,
                            decoration: const InputDecoration(
                              labelText: 'Raw Material',
                            ),
                            items: materials
                                .map(
                                  (m) => DropdownMenuItem(
                                    value: m.id,
                                    child: Text('${m.name} (${m.unit})'),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                ref
                                    .read(dpsFormProvider.notifier)
                                    .updateConsumptionLog(
                                      index,
                                      log.copyWith(rawMaterialId: val),
                                    );
                              }
                            },
                          );
                        },
                        loading: () =>
                            CircularProgressIndicator(color: AppColors.primary),
                        error: (error, stackTrace) => Text(
                          'Error',
                          style: TextStyle(color: AppColors.errorText),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: log.quantity.toString(),
                        decoration: const InputDecoration(labelText: 'Qty'),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        onChanged: (val) {
                          final parsed = double.tryParse(val) ?? 0.0;
                          ref
                              .read(dpsFormProvider.notifier)
                              .updateConsumptionLog(
                                index,
                                log.copyWith(quantity: parsed),
                              );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.errorText),
                      onPressed: () {
                        ref
                            .read(dpsFormProvider.notifier)
                            .removeConsumptionLog(index);
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

class _MachineActivityCard extends ConsumerWidget {
  final Machine machine;
  final int order;
  const _MachineActivityCard({required this.machine, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(dpsFormProvider);
    final productionLogs = formState.productionLogs[machine.id] ?? [];
    final damageLogs = formState.damageLogs[machine.id] ?? [];
    final productsAsync = ref.watch(getAllProductsProvider);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      color: AppColors.textWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Machine Header — numbered badge keeps order visible in the grid
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      '$order',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      machine.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Production Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Production',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.successText,
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.successText,
                  ),
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
                  label: const Text('Add Product Row'),
                ),
              ],
            ),
            ...productionLogs.asMap().entries.map((entry) {
              final index = entry.key;
              final log = entry.value;

              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: productsAsync.when(
                        data: (products) => DropdownButtonFormField<int>(
                          initialValue: log.productId,
                          decoration: const InputDecoration(
                            labelText: 'Product',
                            isDense: true,
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
                        loading: () =>
                            CircularProgressIndicator(color: AppColors.primary),
                        error: (error, stackTrace) => Text(
                          'Error',
                          style: TextStyle(color: AppColors.errorText),
                        ),
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
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
                      icon: Icon(Icons.delete, color: AppColors.errorText),
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

            Divider(height: 32, color: AppColors.dividerColor),

            // Damage Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Damage',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorText,
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.errorText,
                  ),
                  onPressed: productsAsync.when(
                    data: (products) => products.isEmpty
                        ? null
                        : () {
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
                          },
                    loading: () => null,
                    error: (error, stackTrace) => null,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product Row'),
                ),
              ],
            ),
            ...damageLogs.asMap().entries.map((entry) {
              final index = entry.key;
              final log = entry.value;

              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: productsAsync.when(
                        data: (products) => DropdownButtonFormField<int>(
                          initialValue: log.itemId,
                          decoration: const InputDecoration(
                            labelText: 'Damaged Product',
                            isDense: true,
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
                            CircularProgressIndicator(color: AppColors.primary),
                        error: (error, stackTrace) => Text(
                          'Error',
                          style: TextStyle(color: AppColors.errorText),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
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
                          isDense: true,
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
                      icon: Icon(Icons.delete, color: AppColors.errorText),
                      onPressed: () {
                        ref
                            .read(dpsFormProvider.notifier)
                            .removeDamageLog(machine.id, index);
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
