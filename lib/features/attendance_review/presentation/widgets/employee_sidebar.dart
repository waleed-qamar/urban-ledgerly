import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_review_providers.dart';
import '../providers/attendance_edit_state_provider.dart';

class EmployeeSidebar extends ConsumerStatefulWidget {
  const EmployeeSidebar({super.key});

  @override
  ConsumerState<EmployeeSidebar> createState() => _EmployeeSidebarState();
}

class _EmployeeSidebarState extends ConsumerState<EmployeeSidebar> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(attendanceReviewFilterProvider);
    final operatorsAsync = ref.watch(attendanceOperatorsProvider);

    return Container(
      width: 230,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search operator...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: operatorsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Error loading operators: $err',
                      style: const TextStyle(color: Colors.red)),
                ),
              ),
              data: (operators) {
                final filtered = _search.isEmpty
                    ? operators
                    : operators
                        .where((o) => o.name.toLowerCase().contains(_search))
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No operators found.'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final op = filtered[index];
                    final isSelected = filter.operatorId == op.id;
                    final draftsForOp =
                        ref.watch(attendanceEditDraftsProvider(op.id));
                    final hasDraft = draftsForOp.isNotEmpty;

                    return ListTile(
                      dense: true,
                      title: Text(
                        op.name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      trailing: hasDraft
                          ? const Tooltip(
                              message: 'Unsaved changes',
                              child: Icon(Icons.edit,
                                  color: Colors.orange, size: 16),
                            )
                          : null,
                      onTap: () async {
                        if (isSelected) return;

                        // Warn about unsaved drafts before switching
                        if (filter.operatorId != null) {
                          final drafts = ref.read(
                              attendanceEditDraftsProvider(filter.operatorId!));
                          if (drafts.isNotEmpty) {
                            final discard = await _showDiscardDialog(context);
                            if (discard != true) return;
                            ref
                                .read(attendanceEditDraftsProvider(
                                        filter.operatorId!)
                                    .notifier)
                                .clearAll();
                          }
                        }

                        ref
                            .read(attendanceReviewFilterProvider.notifier)
                            .selectOperator(op.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDiscardDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:
                const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
