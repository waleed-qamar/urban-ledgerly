import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/procurement/domain/entities/procurement_entity.dart';
import 'package:ledgerly/features/procurement/presentation/pages/add_procurement.dart';
import 'package:ledgerly/features/procurement/presentation/providers/procurement_providers.dart';
import 'package:ledgerly/features/raw_material/domain/entities/raw_material_entity.dart';
import 'package:ledgerly/features/raw_material/presentation/providers/raw_material_providers.dart';
import 'package:ledgerly/features/vender/domain/entities/vendor_entity.dart';
import 'package:ledgerly/features/vender/presentation/providers/vendor_providers.dart';

class ProcurementDashboard extends ConsumerStatefulWidget {
  const ProcurementDashboard({super.key});

  @override
  ConsumerState<ProcurementDashboard> createState() =>
      _ProcurementDashboardState();
}

class _ProcurementDashboardState extends ConsumerState<ProcurementDashboard> {
  int? _selectedFilterVendorId;
  int? _selectedFilterMaterialId;
  DateTimeRange? _selectedFilterRange;

  Future<void> _openFilterDialog({
    required List<VendorEntity> vendors,
    required List<RawMaterialEntity> materials,
  }) async {
    int? tempVendorId = _selectedFilterVendorId;
    int? tempMaterialId = _selectedFilterMaterialId;
    DateTimeRange? tempRange = _selectedFilterRange;

    final shouldApply = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Procurements'),
              content: SizedBox(
                width: 460,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<int?>(
                      initialValue: tempVendorId,
                      decoration: const InputDecoration(
                        labelText: 'Vendor',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('All Vendors'),
                        ),
                        ...vendors.map(
                          (vendor) => DropdownMenuItem<int?>(
                            value: vendor.id,
                            child: Text(vendor.vendorName),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          tempVendorId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<int?>(
                      initialValue: tempMaterialId,
                      decoration: const InputDecoration(
                        labelText: 'Raw Material',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('All Materials'),
                        ),
                        ...materials.map(
                          (material) => DropdownMenuItem<int?>(
                            value: material.id,
                            child: Text(material.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          tempMaterialId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Date Range',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDateRange: tempRange,
                              );
                              if (picked != null) {
                                setDialogState(() {
                                  tempRange = picked;
                                });
                              }
                            },
                            icon: const Icon(Icons.date_range_outlined),
                            label: Text(
                              tempRange == null
                                  ? 'Select Date Range'
                                  : '${DateFormat('dd MMM yyyy').format(tempRange!.start)} - ${DateFormat('dd MMM yyyy').format(tempRange!.end)}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      tempVendorId = null;
                      tempMaterialId = null;
                      tempRange = null;
                    });
                  },
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldApply == true && mounted) {
      setState(() {
        _selectedFilterVendorId = tempVendorId;
        _selectedFilterMaterialId = tempMaterialId;
        _selectedFilterRange = tempRange;
      });
    }
  }

  List<ProcurementEntity> _applyFilters(List<ProcurementEntity> input) {
    return input.where((item) {
      if (_selectedFilterVendorId != null &&
          item.vendorId != _selectedFilterVendorId) {
        return false;
      }
      if (_selectedFilterMaterialId != null &&
          item.rawMaterialId != _selectedFilterMaterialId) {
        return false;
      }

      if (_selectedFilterRange != null) {
        final parsed = DateTime.tryParse(item.procurementDate);
        if (parsed == null) {
          return false;
        }

        final itemDate = DateTime(parsed.year, parsed.month, parsed.day);
        final start = DateTime(
          _selectedFilterRange!.start.year,
          _selectedFilterRange!.start.month,
          _selectedFilterRange!.start.day,
        );
        final end = DateTime(
          _selectedFilterRange!.end.year,
          _selectedFilterRange!.end.month,
          _selectedFilterRange!.end.day,
        );

        if (itemDate.isBefore(start) || itemDate.isAfter(end)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final procurementsAsync = ref.watch(getAllProcurementsProvider);
    final materialsAsync = ref.watch(getAllRawMaterialsProvider);
    final vendorsAsync = ref.watch(getAllvendorsProvider);

    final materialsById = {
      for (final material
          in materialsAsync.asData?.value ?? <RawMaterialEntity>[])
        material.id: material,
    };
    final vendorsById = {
      for (final vendor in vendorsAsync.asData?.value ?? <VendorEntity>[])
        vendor.id: vendor,
    };

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Procurements',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                      ),
                      // const SizedBox(height: 6),
                      // const Text(
                      //   'Review and manage recent material requisitions and supplier invoices.',
                      //   style: TextStyle(color: AppColors.textGrey),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    _openFilterDialog(
                      vendors: vendorsAsync.asData?.value ?? const [],
                      materials: materialsAsync.asData?.value ?? const [],
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
                const SizedBox(width: 10),
                // OutlinedButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(Icons.file_download_outlined),
                //   label: const Text('Export'),
                // ),
                // const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () async {
                    final added = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const AddProcurementDialog(),
                    );
                    if (added == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Procurement saved.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Procurement'),
                ),
              ],
            ),
            const SizedBox(height: 26),
            // procurementsAsync.when(
            //   loading: () => const SizedBox(
            //     height: 160,
            //     child: Center(child: CircularProgressIndicator()),
            //   ),
            //   error: (error, _) => Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(20),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(16),
            //       color: AppColors.errorBackground.withValues(alpha: 0.12),
            //     ),
            //     child: Text(
            //       'Failed to load procurement summary: $error',
            //       style: const TextStyle(color: AppColors.errorText),
            //     ),
            //   ),
            //   data: (procurements) {
            //     final filtered = _applyFilters(procurements);
            //     final totalAmount = filtered.fold<double>(
            //       0,
            //       (sum, item) => sum + item.total,
            //     );
            //     final totalPurchases = filtered.length;
            //     final pendingReconciliations = filtered
            //         .where((item) => (item.notes ?? '').trim().isEmpty)
            //         .length;

            //     return SizedBox(
            //       height: 185,
            //       child: Row(
            //         children: [
            //           Expanded(
            //             child: _SummaryCard(
            //               title: 'TOTAL AMOUNT DISBURSED',
            //               value: 'Rs. ${_money(totalAmount)}',
            //               subtitle: 'Filtered total',
            //               icon: Icons.receipt_long,
            //               subtitleColor: AppColors.primary,
            //             ),
            //           ),
            //           const SizedBox(width: 14),
            //           Expanded(
            //             child: _SummaryCard(
            //               title: 'TOTAL PURCHASES',
            //               value: totalPurchases.toString(),
            //               subtitle:
            //                   'Pending Reconciliations: $pendingReconciliations',
            //               icon: Icons.inventory_2_outlined,
            //             ),
            //           ),
            //           const SizedBox(width: 14),
            //           const Expanded(child: _QuickActionCard()),
            //         ],
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(height: 30),
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 16),
            const _TableHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: procurementsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load transactions: $error',
                    style: const TextStyle(color: AppColors.errorText),
                  ),
                ),
                data: (procurements) {
                  final filtered = _applyFilters(procurements);

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        'No procurements found for current filters.',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    );
                  }

                  final sorted = [...filtered]
                    ..sort(
                      (a, b) => b.procurementDate.compareTo(a.procurementDate),
                    );

                  return ListView.separated(
                    itemCount: sorted.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = sorted[index];
                      final materialName =
                          materialsById[item.rawMaterialId]?.name ??
                          'Raw Material #${item.rawMaterialId}';
                      final vendorName =
                          vendorsById[item.vendorId]?.vendorName ??
                          'Vendor #${item.vendorId}';

                      return _TransactionRow(
                        procurement: item,
                        materialName: materialName,
                        vendorName: vendorName,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _SummaryCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String subtitle;
//   final IconData icon;
//   final Color subtitleColor;

//   const _SummaryCard({
//     required this.title,
//     required this.value,
//     required this.subtitle,
//     required this.icon,
//     this.subtitleColor = AppColors.textGrey,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.textWhite,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.dividerColor.withValues(alpha: 0.4),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 14,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     color: AppColors.textGrey,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 11,
//                   ),
//                 ),
//               ),
//               Icon(icon, color: AppColors.textGrey),
//             ],
//           ),
//           const Spacer(),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 38,
//               height: 0.95,
//               fontWeight: FontWeight.bold,
//               color: AppColors.textBlack,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: TextStyle(color: subtitleColor, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _QuickActionCard extends StatelessWidget {
//   const _QuickActionCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.primaryDark,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'QUICK ACTION',
//             style: TextStyle(
//               color: Colors.white70,
//               fontWeight: FontWeight.w600,
//               fontSize: 11,
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Generate Procurement Report',
//             style: TextStyle(
//               color: AppColors.textWhite,
//               fontWeight: FontWeight.w600,
//               fontSize: 30,
//               height: 1.03,
//             ),
//           ),
//           const Spacer(),
//           ElevatedButton.icon(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: AppColors.textWhite,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             icon: const Icon(Icons.arrow_forward),
//             label: const Text('Generate Now'),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text('DATE')),
          Expanded(flex: 3, child: Text('SUPPLIER')),
          Expanded(flex: 3, child: Text('MATERIAL')),
          Expanded(flex: 3, child: Text('QTY & RATE')),
          Expanded(flex: 2, child: Text('TOTAL', textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final ProcurementEntity procurement;
  final String materialName;
  final String vendorName;

  const _TransactionRow({
    required this.procurement,
    required this.materialName,
    required this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(_prettyDate(procurement.procurementDate)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              vendorName,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.indicatorBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    materialName,
                    style: TextStyle(
                      color: AppColors.indicatorText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  procurement.quantity.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '@ Rs. ${_money(procurement.price)}',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rs. ${_money(procurement.total)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

String _money(double amount) => NumberFormat('#,##0.00').format(amount);

String _prettyDate(String value) {
  try {
    final parsed = DateTime.parse(value);
    return DateFormat('dd-MM-yy').format(parsed);
  } catch (_) {
    return value;
  }
}
