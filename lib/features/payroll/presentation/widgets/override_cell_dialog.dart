import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import '../../domain/entities/payroll_row_entity.dart';

class OverrideCellDialog extends StatefulWidget {
  final PayrollRowEntity row;
  final String fieldKey;
  final String fieldTitle;
  final double autoCalculatedValue;

  const OverrideCellDialog({
    super.key,
    required this.row,
    required this.fieldKey,
    required this.fieldTitle,
    required this.autoCalculatedValue,
  });

  @override
  State<OverrideCellDialog> createState() => _OverrideCellDialogState();
}

class _OverrideCellDialogState extends State<OverrideCellDialog> {
  late final TextEditingController _overrideController;
  late bool _isOverridden;

  @override
  void initState() {
    super.initState();
    _isOverridden = widget.row.overrides.containsKey(widget.fieldKey);
    final currentValue = _isOverridden
        ? widget.row.overrides[widget.fieldKey]
        : widget.autoCalculatedValue;

    _overrideController = TextEditingController(
      text: (currentValue as num).toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _overrideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: Text('Edit ${widget.fieldTitle} for ${widget.row.nameSnapshot}'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Formula Value: ',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                  ),
                  Text(
                    '₨ ${widget.autoCalculatedValue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _overrideController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: 'Payable Amount (PKR)',
                prefixText: '₨ ',
                border: const OutlineInputBorder(),
                helperText: _isOverridden
                    ? 'Currently overridden from formula'
                    : 'Enter custom amount to override formula',
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (_isOverridden)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.orange[800]),
            onPressed: () {
              // Return null to clear override
              Navigator.of(context).pop({'clear': true});
            },
            child: const Text('Reset to Auto'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
          ),
          onPressed: () {
            final val = double.tryParse(_overrideController.text.trim());
            if (val != null) {
              Navigator.of(context).pop({'value': val});
            }
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
