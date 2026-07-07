import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/features/auth/presentation/provider/current_employee_provider.dart';

class AuditLogListWidget extends ConsumerWidget {
  final String tableName;
  final String recordId;

  const AuditLogListWidget({
    super.key,
    required this.tableName,
    required this.recordId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Check if user has permission to see audit logs ('employees.update')
    final hasAccess = ref.watch(hasPermissionProvider('employees.update'));
    if (!hasAccess) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.badgeBackground.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.badgeBackground),
        ),
        child: const Row(
          children: [
            Icon(Icons.lock_outline, color: Color(0xFFC62828)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Audit log history is restricted. You do not have permission to view logs.',
                style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    // 2. Fetch logs from Supabase
    final supabase = ref.watch(supabaseClientProvider);
    final logsFuture = supabase
        .from('audit_logs')
        .select()
        .eq('table_name', tableName)
        .eq('record_id', recordId)
        .order('changed_at', ascending: false);

    return FutureBuilder<List<dynamic>>(
      future: logsFuture.then((value) => value as List<dynamic>),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Failed to load history logs: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final logs = snapshot.data ?? [];
        if (logs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No activity logs found for this record.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index] as Map<String, dynamic>;
            final action = (log['action'] ?? 'UPDATE').toString().toUpperCase();
            final description = (log['description'] ?? 'No description available.').toString();
            final changedByName = (log['changed_by_name'] ?? 'System').toString();
            final changedAtStr = log['changed_at'] ?? DateTime.now().toIso8601String();
            final DateTime changedAt = DateTime.tryParse(changedAtStr) ?? DateTime.now();

            IconData icon = Icons.edit_note;
            Color iconColor = Colors.blue;
            Color circleColor = Colors.blue.shade50;

            if (action == 'INSERT' || action == 'CREATE') {
              icon = Icons.add_circle_outline;
              iconColor = Colors.green;
              circleColor = Colors.green.shade50;
            } else if (action == 'DELETE' || action == 'DEACTIVATE') {
              icon = Icons.remove_circle_outline;
              iconColor = Colors.red;
              circleColor = Colors.red.shade50;
            }

            final formattedTime = DateFormat('MMM d, yyyy h:mm a').format(changedAt);

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Timeline line & circle
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      if (index < logs.length - 1)
                        Expanded(
                          child: VerticalDivider(
                            thickness: 2,
                            width: 2,
                            color: Colors.grey.shade200,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Log details card
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                action,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: iconColor,
                                  fontSize: 12,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textBlack,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Performed by: $changedByName',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textGrey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
