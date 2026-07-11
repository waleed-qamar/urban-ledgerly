import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/core/widgets/build_search_box.dart';
import 'package:ledgerly/features/auth/presentation/provider/current_employee_provider.dart';
import 'package:ledgerly/features/employee/presentation/provider/operator_providers.dart';
import 'add_user_dialog.dart';

class UsersDashboard extends ConsumerStatefulWidget {
  const UsersDashboard({super.key});

  @override
  ConsumerState<UsersDashboard> createState() => _UsersDashboardState();
}

class _UsersDashboardState extends ConsumerState<UsersDashboard>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        title: const Text(
          'Users & Access Control',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.textWhite,
        foregroundColor: AppColors.textBlack,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Users Roster'),
            Tab(icon: Icon(Icons.security), text: 'RBAC Access Matrix'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUsersRosterTab(), _buildRbacMatrixTab()],
      ),
    );
  }

  Widget _buildUsersRosterTab() {
    final employeesAsync = ref.watch(getAllEmployeesProvider);
    final searchQuery = ref.watch(employeeSearchQueryProvider);

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Company Users',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddUserDialog(),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('New User'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BuildSearchBox(
            searchController: _searchController,
            searchQueryProvider: employeeSearchQueryProvider,
            onQueryChanged: (value) => ref
                .read(employeeSearchQueryProvider.notifier)
                .setSearchQuery(value),
            hintText: 'Search user by name or phone...',
          ),
          const SizedBox(height: 24),
          Expanded(
            child: employeesAsync.when(
              data: (users) {
                var filtered = users;
                if (searchQuery.trim().isNotEmpty) {
                  final q = searchQuery.toLowerCase().trim();
                  filtered = users
                      .where(
                        (u) =>
                            u.name.toLowerCase().contains(q) ||
                            u.phone.toLowerCase().contains(q),
                      )
                      .toList();
                }

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found.',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final user = filtered[index];
                    final initial = user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?';

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.dividerColor.withValues(alpha: 0.4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textGrey.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.lightBackground,
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.phone,
                                  style: const TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Role',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  (user.role ?? 'No Role').toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: user.isActive
                                  ? const Color(0xFFE8F5E9)
                                  : AppColors.badgeBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: user.isActive
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            color: AppColors.textWhite,
                            onSelected: (val) async {
                              if (val == 'edit') {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AddUserDialog(userToEdit: user),
                                );
                              } else if (val == 'deactivate') {
                                try {
                                  await ref
                                      .read(operatorRepositoryProvider)
                                      .deactivateCompanyEmployee(user.id);
                                  ref.invalidate(getAllEmployeesProvider);
                                  ref.invalidate(currentEmployeeProvider);
                                  ref.invalidate(userPermissionsProvider);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'User deactivated successfully.',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              if (user.isActive)
                                const PopupMenuItem(
                                  value: 'deactivate',
                                  child: Text('Deactivate'),
                                ),
                            ],
                            icon: const Icon(Icons.more_vert),
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
    );
  }

  Widget _buildRbacMatrixTab() {
    final rolesAsync = ref.watch(getAllRolesProvider);
    final permissionsAsync = ref.watch(getAllPermissionsProvider);
    final rolePermissionsAsync = ref.watch(getRolePermissionsProvider);

    return rolesAsync.when(
      data: (roles) => permissionsAsync.when(
        data: (permissions) => rolePermissionsAsync.when(
          data: (rolePermissions) {
            // Filter out system owner 'master' to prevent breaking essential access policies.
            final editableRoles = roles
                .where((r) => r['name']?.toString().trim().toLowerCase() != 'master')
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Role Permission Matrix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Changes made below instantly update Supabase Row-Level Security (RLS) policies and active user sessions.',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              AppColors.primary.withValues(alpha: 0.05),
                            ),
                            columns: [
                              const DataColumn(
                                label: Text(
                                  'Module Permission Key',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              ...editableRoles.map(
                                (r) => DataColumn(
                                  label: Text(
                                    r['name'].toString().toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: permissions.map((p) {
                              final permId = p['id'] as int;
                              final permKey = p['key'] as String;

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      permKey,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 13,
                                        color: AppColors.textBlack87,
                                      ),
                                    ),
                                  ),
                                  ...editableRoles.map((r) {
                                    final roleId = r['id'] as int;
                                    final isAssigned = rolePermissions.any(
                                      (rp) =>
                                          rp['role_id'] == roleId &&
                                          rp['permission_id'] == permId,
                                    );

                                    return DataCell(
                                      Checkbox(
                                        activeColor: AppColors.primary,
                                        value: isAssigned,
                                        onChanged: (checked) async {
                                          try {
                                            if (checked == true) {
                                              await ref
                                                  .read(
                                                    operatorRepositoryProvider,
                                                  )
                                                  .addRolePermission(
                                                    roleId,
                                                    permId,
                                                  );
                                            } else {
                                              await ref
                                                  .read(
                                                    operatorRepositoryProvider,
                                                  )
                                                  .removeRolePermission(
                                                    roleId,
                                                    permId,
                                                  );
                                            }
                                            ref.invalidate(
                                              getRolePermissionsProvider,
                                            );
                                            ref.invalidate(
                                              userPermissionsProvider,
                                            );
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text('Error: $e'),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
