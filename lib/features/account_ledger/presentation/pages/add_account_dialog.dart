import 'package:flutter/material.dart';
import 'package:ledgerly/core/theme/app_colors.dart';

import '../../domain/entities/account_entity.dart';

/// Account types stored in DB (lowercase).
enum AccountTypeOption { cash, bank }

extension AccountTypeOptionX on AccountTypeOption {
  String get dbValue => name; // 'cash' | 'bank'

  String get label => switch (this) {
    AccountTypeOption.cash => 'Cash',
    AccountTypeOption.bank => 'Bank',
  };

  static AccountTypeOption fromDb(String value) {
    return AccountTypeOption.values.firstWhere(
      (e) => e.dbValue == value.toLowerCase(),
      orElse: () => AccountTypeOption.cash,
    );
  }
}

/// A dialog for creating a new account or editing an existing one.
///
/// Usage:
/// ```dart
/// // Add mode
/// AccountFormDialog.show(
///   context,
///   onSave: (account) async {
///     await ref.read(accountRepositoryProvider).createAccount(account);
///   },
/// );
///
/// // Edit mode
/// AccountFormDialog.show(
///   context,
///   account: existingAccount,
///   onSave: (account) async {
///     await ref.read(accountRepositoryProvider).updateAccount(account);
///   },
/// );
/// ```
class AccountFormDialog extends StatefulWidget {
  const AccountFormDialog({super.key, this.account, required this.onSave});

  /// Pass an existing [AccountEntity] to open the dialog in edit mode.
  /// Leave null to open in "add new account" mode.
  final AccountEntity? account;

  /// Called with the built [AccountEntity] when the user taps Save.
  /// Throw inside this callback (e.g. on a Supabase error) to have the
  /// dialog surface the error and stay open for correction.
  final Future<void> Function(AccountEntity account) onSave;

  bool get isEditMode => account != null;

  static Future<void> show(
    BuildContext context, {
    AccountEntity? account,
    required Future<void> Function(AccountEntity account) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AccountFormDialog(account: account, onSave: onSave),
    );
  }

  @override
  State<AccountFormDialog> createState() => _AccountFormDialogState();
}

class _AccountFormDialogState extends State<AccountFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _currencyController;
  // late final TextEditingController _balanceController;

  late AccountTypeOption _selectedType;
  late bool _isActive;

  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final account = widget.account;

    _titleController = TextEditingController(text: account?.accountTitle ?? '');
    _bankNameController = TextEditingController(text: account?.bankName ?? '');
    _accountNumberController = TextEditingController(
      text: account?.accountNumber ?? '',
    );
    _currencyController = TextEditingController(
      text: account?.currency ?? 'PKR',
    );
    // _balanceController = TextEditingController(
    //   text: (account?.currentBalance ?? 0.0).toStringAsFixed(2),
    // );

    _selectedType = account != null
        ? AccountTypeOptionX.fromDb(account.accountType)
        : AccountTypeOption.cash;
    _isActive = account?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _currencyController.dispose();
    // _balanceController.dispose();
    super.dispose();
  }

  bool get _isBank => _selectedType == AccountTypeOption.bank;

  Future<void> _handleSave() async {
    setState(() => _errorText = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final result = AccountEntity(
      id: widget.account?.id ?? 0,
      accountTitle: _titleController.text.trim(),
      accountType: _selectedType.dbValue,
      bankName: _isBank && _bankNameController.text.trim().isNotEmpty
          ? _bankNameController.text.trim()
          : null,
      accountNumber: _isBank && _accountNumberController.text.trim().isNotEmpty
          ? _accountNumberController.text.trim()
          : null,
      currency: _currencyController.text.trim().toUpperCase(),
      isActive: _isActive,
      createdAt: widget.account?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await widget.onSave(result);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _errorText = 'Failed to save account: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.lightBackground,
      title: Text(widget.isEditMode ? 'Edit Account' : 'Add Account'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Account Title',
                    hintText: 'e.g. Main Cash Drawer, HBL Current A/C',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Account title is required';
                    if (v.length < 2) return 'Title is too short';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<AccountTypeOption>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(labelText: 'Account Type'),
                  items: AccountTypeOption.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedType = value);
                  },
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isBank
                      ? Column(
                          key: const ValueKey('bank-fields'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _bankNameController,
                              decoration: const InputDecoration(
                                labelText: 'Bank Name',
                                hintText: 'e.g. HBL, Meezan Bank',
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (!_isBank) return null;
                                if ((value ?? '').trim().isEmpty) {
                                  return 'Bank name is required for bank accounts';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _accountNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Account Number (optional)',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox.shrink(key: ValueKey('no-bank-fields')),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _currencyController,
                        decoration: const InputDecoration(
                          labelText: 'Currency',
                        ),
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 3,
                        validator: (value) {
                          final v = value?.trim() ?? '';
                          if (v.isEmpty) return 'Required';
                          if (v.length != 3) return '3-letter code';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Expanded(
                    //   child: TextFormField(
                    //     controller: _balanceController,
                    //     decoration: const InputDecoration(
                    //       labelText: 'Current Balance',
                    //     ),
                    //     keyboardType: const TextInputType.numberWithOptions(
                    //       decimal: true,
                    //     ),
                    //     validator: (value) {
                    //       final v = value?.trim() ?? '';
                    //       if (v.isEmpty) return 'Required';
                    //       if (double.tryParse(v) == null) {
                    //         return 'Invalid number';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _handleSave,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.isEditMode ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}
