import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/employee/presentation/provider/operator_providers.dart';
import 'add_operator_dialog.dart';

class OperatorDashboard extends ConsumerWidget {
  const OperatorDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsyncValue = ref.watch(getAllOperatorsProvider);

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

            // Employee List
            Expanded(
              child: employeeAsyncValue.when(
                data: (employees) {
                  if (employees.isEmpty) {
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
                    itemCount: employees.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final emp = employees[index];

                      final initial = (emp.name).isNotEmpty
                          ? emp.name[0].toUpperCase()
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

                            // Name & Role
                            Expanded(
                              flex: 3,
                              child: Text(
                                emp.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textBlack,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Contact
                            Expanded(
                              flex: 3,
                              child: Text(
                                emp.phone,
                                style: const TextStyle(
                                  color: AppColors.textBlack87,
                                  fontSize: 14,
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
                                    color: (emp.isActive)
                                        ? const Color(0xFFE8F5E9)
                                        : AppColors.badgeBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(radius: 4),
                                      const SizedBox(width: 8),
                                      Text(
                                        (emp.isActive) ? 'Active' : 'Inactive',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Actions
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PopupMenuButton<String>(
                                    color: AppColors.textWhite,
                                    onSelected: (val) async {
                                      // implement actions: edit / mark inactive
                                      if (val == 'edit') {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AddEmployeeDialog(
                                            clientToEdit: emp,
                                          ),
                                        );
                                      } else if (val == 'mark_inactive') {
                                        // placeholder: call repo to toggle
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem(
                                        value: 'mark_inactive',
                                        child: Text('Toggle Active'),
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
