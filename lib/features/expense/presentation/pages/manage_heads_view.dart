import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_providers.dart';
import 'add_expense_head_dialog.dart';

class ManageHeadsView extends ConsumerWidget {
  const ManageHeadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headsAsync = ref.watch(expenseHeadsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Expense Heads')),
      body: headsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
        data: (heads) {
          if (heads.isEmpty) {
            return const Center(child: Text('No heads found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: heads.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final head = heads[index];
              return Dismissible(
                key: ValueKey(head.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red.shade400,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Head?'),
                      content: const Text(
                        'This will delete all associated expenses. Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  // Call your delete logic here
                  ref
                      .read(expenseRepositoryProvider)
                      .deleteExpenseHead(head.id);
                  ref.invalidate(expenseHeadsProvider);
                },
                child: ListTile(
                  title: Text(
                    head.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text('${head.description}\n${head.headType.value}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AddExpenseHeadDialog(
                          headToEdit: head,
                        ), // Pass the head here!
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
