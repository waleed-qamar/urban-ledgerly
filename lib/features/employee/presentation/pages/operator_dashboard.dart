import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/core/widgets/build_search_box.dart';
import 'package:ledgerly/features/employee/presentation/provider/operator_providers.dart';
import 'add_operator_dialog.dart';

class OperatorDashboard extends ConsumerStatefulWidget {
  const OperatorDashboard({super.key});

  @override
  ConsumerState<OperatorDashboard> createState() => _OperatorDashboardState();
}

class _OperatorDashboardState extends ConsumerState<OperatorDashboard> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeAsyncValue = ref.watch(getAllOperatorsProvider);
    final searchQuery = ref.watch(operatorSearchQueryProvider);

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
                  'Employees',
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
                      builder: (context) => const AddEmployeeDialog(),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('New Employee'),
                ),
              ],
            ),

            const SizedBox(height: 48),
            BuildSearchBox(
              searchController: _searchController,
              searchQueryProvider: operatorSearchQueryProvider,
              onQueryChanged: (value) => ref
                  .read(operatorSearchQueryProvider.notifier)
                  .setSearchQuery(value),
              hintText: 'Search Employee by name or phone number ...',
            ),

            // Employee List
            Expanded(
              child: employeeAsyncValue.when(
                data: (employees) {
                  var emp = employees;
                  if (searchQuery.trim().isNotEmpty) {
                    final query = searchQuery.trim().toLowerCase();
                    emp = employees
                        .where(
                          (e) =>
                              e.name.toLowerCase().contains(query) ||
                              e.phone.toLowerCase().contains(query),
                        )
                        .toList();
                  }
                  if (emp.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'No employees found.',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                          const SizedBox(height: 16),
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
                                builder: (context) => const AddEmployeeDialog(),
                              );
                            },
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('New Employee'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: emp.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final semp = emp[index];

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
                            // ID / Sr.
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#${semp.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Name & CNIC
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    semp.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.textBlack,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (semp.cnic != null && semp.cnic!.isNotEmpty)
                                    Text(
                                      'CNIC: ${semp.cnic}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Contact
                            Expanded(
                              flex: 2,
                              child: Text(
                                semp.phone,
                                style: const TextStyle(
                                  color: AppColors.textBlack87,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Daily Rate (Per Day)
                            Expanded(
                              flex: 2,
                              child: Text(
                                semp.defaultPerDay > 0
                                    ? '₨ ${semp.defaultPerDay.toStringAsFixed(0)} / day'
                                    : '—',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.textBlack,
                                ),
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
                                    color: (semp.isActive)
                                        ? const Color(0xFFE8F5E9)
                                        : AppColors.badgeBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 4,
                                        backgroundColor: (semp.isActive)
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        (semp.isActive) ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: (semp.isActive)
                                              ? Colors.green[800]
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Actions
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PopupMenuButton<String>(
                                    color: AppColors.textWhite,
                                    onSelected: (val) async {
                                      if (val == 'edit') {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AddEmployeeDialog(
                                            clientToEdit: semp,
                                          ),
                                        );
                                      } else if (val == 'toggle_active') {
                                        await ref
                                            .read(operatorRepositoryProvider)
                                            .updateEmployee(
                                              semp.copyWith(isActive: !semp.isActive),
                                            );
                                        ref.invalidate(getAllOperatorsProvider);
                                      } else if (val == 'delete') {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Delete Employee'),
                                            content: Text(
                                              'Are you sure you want to delete ${semp.name}?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(ctx, false),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                ),
                                                onPressed: () => Navigator.pop(ctx, true),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          try {
                                            await ref
                                                .read(operatorRepositoryProvider)
                                                .deleteEmployee(semp.id);
                                            ref.invalidate(getAllOperatorsProvider);
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Cannot delete: $e')),
                                              );
                                            }
                                          }
                                        }
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem(
                                        value: 'toggle_active',
                                        child: Text(
                                          semp.isActive
                                              ? 'Mark Inactive'
                                              : 'Reactivate',
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
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
}
