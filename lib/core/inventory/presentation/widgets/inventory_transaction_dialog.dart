import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

class RecordTransactionResult {
  final double quantity;
  final String? notes;
  final DateTime transactionDate;

  RecordTransactionResult({
    required this.quantity,
    this.notes,
    required this.transactionDate,
  });
}

Future<RecordTransactionResult?> showInventoryTransactionDialog({
  required BuildContext context,
  required String transactionType, // 'IN' or 'OUT'
}) async {
  return await showDialog<RecordTransactionResult>(
    context: context,
    builder: (dialogContext) {
      return _InventoryTransactionDialog(
        transactionType: transactionType,
      );
    },
  );
}

class _InventoryTransactionDialog extends StatefulWidget {
  final String transactionType;

  const _InventoryTransactionDialog({required this.transactionType});

  @override
  State<_InventoryTransactionDialog> createState() =>
      _InventoryTransactionDialogState();
}

class _InventoryTransactionDialogState
    extends State<_InventoryTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  String _quantityText = '';
  String _notesText = '';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: Text(widget.transactionType == 'IN' ? 'Add Stock' : 'Remove Stock'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: const InputDecoration(labelText: 'Quantity'),
              onChanged: (value) => _quantityText = value,
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid positive quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
              ),
              maxLines: 2,
              onChanged: (value) => _notesText = value,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Transaction Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today, color: AppColors.primary),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: AppColors.textWhite,
                          onSurface: AppColors.textBlack,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(
                RecordTransactionResult(
                  quantity: double.parse(_quantityText),
                  notes: _notesText.trim().isEmpty ? null : _notesText.trim(),
                  transactionDate: _selectedDate,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
