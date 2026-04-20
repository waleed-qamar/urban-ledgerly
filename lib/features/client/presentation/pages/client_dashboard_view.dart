import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/client_providers.dart';
import 'add_client_dialog.dart';

class ClientDashboardView extends ConsumerWidget {
  const ClientDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(getAllClientsProvider);
    final filter = ref.watch(clientFilterProvider);

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
                  'Clients',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
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
                      builder: (context) => const AddClientDialog(),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('New Client'),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Summary Cards
            clientsAsync.when(
              data: (clients) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'TOTAL CLIENTS',
                        value: clients.length.toString(),
                        subtitle: '+0 this quarter', // Placeholder
                        icon: Icons.business,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'ACTIVE PROJECTS',
                        value: '0', // Placeholder
                        subtitle: 'Across 0 clients', // Placeholder
                        icon: Icons.architecture,
                      ),
                    ),
                    // const SizedBox(width: 24),
                    // Expanded(
                    //   child: _buildSummaryCard(
                    //     title: 'TOTAL REVENUE',
                    //     value: '\$0.0M', // Placeholder
                    //     subtitle: '+0.0% YTD', // Placeholder
                    //     icon: Icons.account_balance,
                    //   ),
                    // ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),

            const SizedBox(height: 48),

            // Filters & Sort
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildFilterPill(
                      'All Clients',
                      isSelected: filter == ClientFilter.all,
                      onTap: () {
                        ref
                            .read(clientFilterProvider.notifier)
                            .setFilter(ClientFilter.all);
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildFilterPill(
                      'Active',
                      isSelected: filter == ClientFilter.active,
                      onTap: () {
                        ref
                            .read(clientFilterProvider.notifier)
                            .setFilter(ClientFilter.active);
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildFilterPill(
                      'Inactive',
                      isSelected: filter == ClientFilter.inactive,
                      onTap: () {
                        ref
                            .read(clientFilterProvider.notifier)
                            .setFilter(ClientFilter.inactive);
                      },
                    ),
                  ],
                ),
                // TextButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.sort,
                //     color: AppColors.textGrey,
                //     size: 20,
                //   ),
                //   label: const Text(
                //     'Sort by Revenue',
                //     style: TextStyle(color: AppColors.textGrey),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 24),

            // Client List
            Expanded(
              child: clientsAsync.when(
                data: (clients) {
                  // Filter logic
                  var filteredList = clients;
                  if (filter == ClientFilter.active) {
                    filteredList = clients.where((c) => c.isActive).toList();
                  } else if (filter == ClientFilter.inactive) {
                    filteredList = clients.where((c) => !c.isActive).toList();
                  }

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No clients found matching the filter.',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final client = filteredList[index];
                      final initial = client.clientName.isNotEmpty
                          ? client.clientName[0].toUpperCase()
                          : '?';

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
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Name & Est
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    client.clientName,
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
                                    'Est. ${client.createdAt.year}',
                                    style: const TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Contact info
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    client.contactNumber,
                                    style: const TextStyle(
                                      color: AppColors.textBlack87,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email_outlined,
                                        size: 14,
                                        color: AppColors.textGrey,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          client.clientAddress,
                                          style: const TextStyle(
                                            color: AppColors.textGrey,
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Department
                            Expanded(
                              flex: 2,
                              child: Text(
                                client.department.isNotEmpty
                                    ? client.department
                                    : '',
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Status Pill
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: client.isActive
                                        ? const Color(0xFFE8F5E9)
                                        : AppColors.badgeBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 4,
                                        backgroundColor: client.isActive
                                            ? Colors.green
                                            : AppColors.textGrey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        client.isActive ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          color: client.isActive
                                              ? Colors.green
                                              : AppColors.textGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Revenue / Action Buttons
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                  //   children: const [
                                  //     Text(
                                  //       '\$0', // Placeholder from Order module
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         fontSize: 16,
                                  //         color: AppColors.textBlack,
                                  //       ),
                                  //     ),
                                  //     SizedBox(height: 4),
                                  //     Text(
                                  //       'YTD REVENUE',
                                  //       style: TextStyle(
                                  //         color: AppColors.textGrey,
                                  //         fontSize: 10,
                                  //         fontWeight: FontWeight.bold,
                                  //         letterSpacing: 0.5,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(width: 16),
                                  PopupMenuButton<String>(
                                    color: AppColors.textWhite,
                                    onSelected: (val) async {
                                      if (val == 'edit') {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AddClientDialog(
                                            clientToEdit: client,
                                          ),
                                        );
                                      } else if (val == 'delete') {
                                        final delete = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Delete Client?'),
                                            content: const Text(
                                              'Are you sure you want to delete this client? This cannot be undone.',
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
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (delete == true) {
                                          await ref
                                              .read(clientRepositoryProvider)
                                              .deleteClient(client.id);
                                          ref.invalidate(getAllClientsProvider);
                                        }
                                      } else if (val == 'mark_inactive') {
                                        await ref
                                            .read(clientRepositoryProvider)
                                            .updateClient(
                                              client.copyWith(isActive: false),
                                            );
                                        ref.invalidate(getAllClientsProvider);
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem(
                                        value: 'mark_inactive',
                                        child: Text(
                                          'Mark Inactive',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      // PopupMenuItem(
                                      //   value: 'delete',
                                      //   child: Text(
                                      //     'Delete',
                                      //     style: TextStyle(color: Colors.red),
                                      //   ),
                                      // ),
                                    ],
                                    icon: const Icon(Icons.more_vert),
                                  ),
                                ],
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

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textGrey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              radius: 20,
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

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
