// features/expense/presentation/views/add_expense_head_dialog.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense_head.dart';
import '../providers/expense_providers.dart';

class AddExpenseHeadDialog extends ConsumerStatefulWidget {
  final ExpenseHead? headToEdit; // Allows passing an existing head

  const AddExpenseHeadDialog({super.key, this.headToEdit});

  @override
  ConsumerState<AddExpenseHeadDialog> createState() =>
      _AddExpenseHeadDialogState();
}

class _AddExpenseHeadDialogState extends ConsumerState<AddExpenseHeadDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late String _selectedType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if we are editing
    _nameController = TextEditingController(
      text: widget.headToEdit?.name ?? '',
    );
    _descController = TextEditingController(
      text: widget.headToEdit?.description ?? '',
    );
    _selectedType = widget.headToEdit?.headType.value ?? 'developmental';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Keep the old ID if editing, otherwise generate a new one
    final head = ExpenseHead(
      id: widget.headToEdit?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      headType: HeadType.values.firstWhere((e) => e.value == _selectedType),
      createdAt: widget.headToEdit?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.headToEdit != null) {
        // Update existing
        await ref.read(expenseRepositoryProvider).updateExpenseHead(head);
        ref.invalidate(expenseHeadsProvider); // Refresh the list
        ScaffoldMessenger.of(context.mounted ? context : context).showSnackBar(
          SnackBar(
            content: Text('Updated Successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Add new
        await ref.read(expenseHeadsProvider.notifier).add(head);
        ScaffoldMessenger.of(context.mounted ? context : context).showSnackBar(
          SnackBar(
            content: Text('Expense Head Added Successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.headToEdit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Expense Head' : 'New Expense Head'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'developmental',
                    child: Text('Developmental'),
                  ),
                  DropdownMenuItem(
                    value: 'nondevelopmental',
                    child: Text('Non-Developmental'),
                  ),
                  DropdownMenuItem(value: 'domestic', child: Text('Domestic')),
                ],
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}
