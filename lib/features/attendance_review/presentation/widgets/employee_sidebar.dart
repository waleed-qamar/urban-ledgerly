import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_review_providers.dart';
import '../providers/attendance_edit_state_provider.dart';

class EmployeeSidebar extends ConsumerWidget {
  const EmployeeSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(attendanceReviewFilterProvider);
    
    // In a real app, this would fetch from a provider that returns the list 
    // of operators, potentially filtered by search/workgroup, and indicating 
    // if they have 'needsReview' status for the current date range.
    // We'll mock this for now.
    final mockOperators = [
      {'id': 1, 'name': 'John Doe', 'needsReview': true},
      {'id': 2, 'name': 'Jane Smith', 'needsReview': false},
      {'id': 3, 'name': 'Mike Johnson', 'needsReview': false},
    ];

    return Container(
      width: 220,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search employee...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mockOperators.length,
              itemBuilder: (context, index) {
                final op = mockOperators[index];
                final id = op['id'] as int;
                final isSelected = filter.operatorId == id;
                final needsReview = op['needsReview'] as bool;

                return ListTile(
                  title: Text(op['name'] as String),
                  selected: isSelected,
                  selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                  trailing: needsReview 
                      ? const Icon(Icons.warning, color: Colors.orange, size: 16)
                      : null,
                  onTap: () async {
                    if (isSelected) return;
                    
                    // Check for unsaved drafts if switching away from current
                    if (filter.operatorId != null) {
                      final drafts = ref.read(attendanceEditDraftsProvider(filter.operatorId!));
                      if (drafts.isNotEmpty) {
                        final discard = await _showDiscardDialog(context);
                        if (discard != true) return;
                        ref.read(attendanceEditDraftsProvider(filter.operatorId!).notifier).clearAll();
                      }
                    }
                    
                    ref.read(attendanceReviewFilterProvider.notifier).selectOperator(id);
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
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
