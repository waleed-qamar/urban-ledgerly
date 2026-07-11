import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/widgets/build_search_box.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/vendor_providers.dart';
import 'add_vendor_dialog.dart';

class VenderDashboardView extends ConsumerStatefulWidget {
  const VenderDashboardView({super.key});

  @override
  ConsumerState<VenderDashboardView> createState() =>
      _VenderDashboardViewState();
}

class _VenderDashboardViewState extends ConsumerState<VenderDashboardView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(getAllvendorsProvider);
    final filter = ref.watch(vendorFilterProvider);
    final searchQuery = ref.watch(vendorSearchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vendors',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddVenderDialog(),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Vendor'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            BuildSearchBox(
              searchController: _searchController,
              searchQueryProvider: vendorSearchQueryProvider,
              onQueryChanged: (value) => ref
                  .read(vendorSearchQueryProvider.notifier)
                  .setSearchQuery(value),
              hintText: 'Search vendors by name, company, contact, or notes...',
            ),
            const SizedBox(height: 24),

            // Summary Cards
            // vendorsAsync.when(
            //   data: (vendors) {
            //     return Row(
            //       children: [
            //         Expanded(
            //           child: _buildSummaryCard(
            //             title: 'Total Debit',
            //             value:
            //                 '500.00', // Mock representation of the screenshot
            //             subtitleLabel: 'PAYABLES',
            //             icon: Icons.account_balance,
            //           ),
            //         ),
            //         const SizedBox(width: 24),
            //         Expanded(
            //           child: _buildSummaryCard(
            //             title: 'Upcoming in 30 Days',
            //             value: '8', // Mock
            //             subtitleLabel: 'RENEWALS',
            //             icon: Icons.calendar_today,
            //             trailingText: 'Contracts',
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            //   loading: () => const Center(child: CircularProgressIndicator()),
            //   error: (err, _) => Center(child: Text('Error: $err')),
            // ),

            // const SizedBox(height: 48),

            // Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      filter == VendorFilter.active
                          ? 'Active Vendors'
                          : filter == VendorFilter.inactive
                          ? 'Inactive Vendors'
                          : 'All Vendors',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(width: 32),
                    _buildFilterPill(
                      'All',
                      isSelected: filter == VendorFilter.all,
                      onTap: () {
                        ref
                            .read(vendorFilterProvider.notifier)
                            .setFilter(VendorFilter.all);
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildFilterPill(
                      'Active',
                      isSelected: filter == VendorFilter.active,
                      onTap: () {
                        ref
                            .read(vendorFilterProvider.notifier)
                            .setFilter(VendorFilter.active);
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildFilterPill(
                      'Inactive',
                      isSelected: filter == VendorFilter.inactive,
                      onTap: () {
                        ref
                            .read(vendorFilterProvider.notifier)
                            .setFilter(VendorFilter.inactive);
                      },
                    ),
                  ],
                ),
                // TextButton(
                //   onPressed: () {
                //     ref
                //         .read(vendorFilterProvider.notifier)
                //         .setFilter(VendorFilter.all);
                //   },
                //   child: const Text(
                //     'View All',
                //     style: TextStyle(
                //       color: AppColors.primaryDark,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 24),

            // Vender List
            Expanded(
              child: vendorsAsync.when(
                data: (venders) {
                  // Filter logic
                  var filteredList = venders;
                  if (filter == VendorFilter.active) {
                    filteredList = venders.where((v) => v.isActive).toList();
                  } else if (filter == VendorFilter.inactive) {
                    filteredList = venders.where((v) => !v.isActive).toList();
                  }

                  if (searchQuery.isNotEmpty) {
                    final query = searchQuery.toLowerCase();
                    filteredList = filteredList
                        .where(
                          (v) =>
                              v.vendorName.toLowerCase().contains(query) ||
                              v.companyName.toLowerCase().contains(query) ||
                              v.vendorNotes.toLowerCase().contains(query) ||
                              v.contactNumber.toLowerCase().contains(query),
                        )
                        .toList();
                  }

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No vendors found matching the filter or search.',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final vender = filteredList[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.dividerColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textGrey.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.lightBackground,
                                borderRadius: BorderRadius.circular(
                                  25,
                                ), // Fully rounded for vendor screenshot
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.textGrey,
                                ), // Mocking the icon
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Name & Company/Notes
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vender.vendorName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.textBlack,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    vender.vendorNotes.isNotEmpty
                                        ? vender.vendorNotes
                                        : vender
                                              .companyName, // Usually "Software" etc.
                                    style: const TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                vender.vendorAddress,
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Balance Due
                            Expanded(
                              flex: 2,
                              child: Text(
                                vender.contactNumber,
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            // const SizedBox(width: 32),

                            // // Last Payment
                            // Expanded(
                            //   flex: 2,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.end,
                            //     children: const [
                            //       Text(
                            //         'Last Payment',
                            //         style: TextStyle(
                            //           color: AppColors.textGrey,
                            //           fontSize: 12,
                            //         ),
                            //       ),
                            //       SizedBox(height: 4),
                            //       Text(
                            //         'Pending', // Mocked placeholder
                            //         style: TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 14,
                            //           color: AppColors.textBlack,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(width: 16),
                            PopupMenuButton<String>(
                              color: AppColors.textWhite,
                              onSelected: (val) async {
                                if (val == 'edit') {
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        AddVenderDialog(venderToEdit: vender),
                                  );
                                } else if (val == 'delete') {
                                  final delete = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: AppColors.textWhite,
                                      title: const Text('Delete Vendor?'),
                                      content: const Text(
                                        'Are you sure you want to delete this vendor? This cannot be undone.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (delete == true) {
                                    await ref
                                        .read(vendorRepositoryProvider)
                                        .deleteVender(vender.id);
                                    ref.invalidate(getAllvendorsProvider);
                                  }
                                } else if (val == 'mark_inactive') {
                                  await ref
                                      .read(vendorRepositoryProvider)
                                      .updateVender(
                                        vender.copyWith(isActive: false),
                                      );
                                  ref.invalidate(getAllvendorsProvider);
                                } else if (val == 'mark_active') {
                                  await ref
                                      .read(vendorRepositoryProvider)
                                      .updateVender(
                                        vender.copyWith(isActive: true),
                                      );
                                  ref.invalidate(getAllvendorsProvider);
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                if (vender.isActive)
                                  const PopupMenuItem(
                                    value: 'mark_inactive',
                                    child: Text(
                                      'Mark Inactive',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                if (!vender.isActive)
                                  const PopupMenuItem(
                                    value: 'mark_active',
                                    child: Text(
                                      'Mark Active',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                // const PopupMenuItem(
                                //   value: 'delete',
                                //   child: Text(
                                //     'Delete',
                                //     style: TextStyle(color: Colors.red),
                                //   ),
                                // ),
                              ],
                              icon: const Icon(
                                Icons.more_horiz,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSummaryCard({
  //   required String title,
  //   required String value,
  //   required String subtitleLabel,
  //   required IconData icon,
  //   String? trailingText,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: AppColors.textWhite,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: AppColors.dividerColor.withValues(alpha: 0.5),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.textGrey.withValues(alpha: 0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const SizedBox(height: 16),
  //             Text(
  //               title,
  //               style: const TextStyle(
  //                 color: AppColors.textGrey,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             Spacer(),
  //             CircleAvatar(
  //               backgroundColor: AppColors.primary.withValues(alpha: 0.1),
  //               radius: 20,
  //               child: Icon(icon, color: AppColors.primary, size: 18),
  //             ),
  //             SizedBox(width: 8),
  //             Text(subtitleLabel, style: const TextStyle(fontSize: 14)),
  //           ],
  //         ),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.baseline,
  //           textBaseline: TextBaseline.alphabetic,
  //           children: [
  //             Text(
  //               value,
  //               style: const TextStyle(
  //                 fontSize: 36,
  //                 fontWeight: FontWeight.bold,
  //                 color: AppColors.textBlack,
  //               ),
  //             ),
  //             if (trailingText != null) ...[
  //               const SizedBox(width: 8),
  //               Text(
  //                 trailingText,
  //                 style: const TextStyle(
  //                   fontSize: 14,
  //                   color: AppColors.textGrey,
  //                 ),
  //               ),
  //             ],
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFilterPill(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.badgeBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.textBlack : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}
