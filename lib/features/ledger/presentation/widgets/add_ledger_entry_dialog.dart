import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ledger_entity.dart';
import '../providers/ledger_providers.dart';
import '../../../../core/widgets/searchable_dropdown.dart';
import '../../../client/domain/entities/client_entity.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../vender/domain/entities/vendor_entity.dart';
import '../../../vender/presentation/providers/vendor_providers.dart';
import 'package:flutter/services.dart';
// import '../../../client/domain/entities/client_entity.dart';
// import '../../../vender/domain/entities/vendor_entity.dart';

class AddLedgerEntryDialog extends ConsumerStatefulWidget {
  final PartyType? initialPartyType;
  final int? initialPartyId;

  const AddLedgerEntryDialog({
    super.key,
    this.initialPartyType,
    this.initialPartyId,
  });

  @override
  ConsumerState<AddLedgerEntryDialog> createState() =>
      _AddLedgerEntryDialogState();
}

class _AddLedgerEntryDialogState extends ConsumerState<AddLedgerEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _remarksController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _invoiceNumberController = TextEditingController();

  PartyType? _selectedPartyType;
  int? _selectedPartyId;
  EntryType _selectedEntryType = EntryType.credit;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedPartyType = widget.initialPartyType;
    _selectedPartyId = widget.initialPartyId;
    _selectedEntryType = _defaultEntryTypeForParty(_selectedPartyType);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarksController.dispose();
    _descriptionController.dispose();
    _invoiceNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(getAllClientsProvider);
    final vendorsAsync = ref.watch(getAllvendorsProvider);

    return AlertDialog(
      backgroundColor: AppColors.textWhite,
      title: const Text(
        'Add Ledger Entry',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date Picker (Moved to top)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),

                // Party Type Selector
                if (widget.initialPartyType == null) ...[
                  DropdownButtonFormField<PartyType>(
                    initialValue: _selectedPartyType,
                    decoration: const InputDecoration(labelText: 'Party Type'),
                    items: PartyType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedPartyType = val;
                        _selectedPartyId = null;
                        _selectedEntryType = _defaultEntryTypeForParty(val);
                      });
                    },
                    validator: (val) => val == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // Party Selector
                if (widget.initialPartyId == null) ...[
                  if (_selectedPartyType == PartyType.client)
                    clientsAsync.when(
                      data: (clients) => SearchableDropdown<ClientEntity>(
                        items: clients,
                        displayStringForOption: (c) => c.clientName,
                        onSelected: (val) => setState(() => _selectedPartyId = val.id),
                        initialText: _selectedPartyId != null
                            ? clients
                                  .where((c) => c.id == _selectedPartyId)
                                  .firstOrNull
                                  ?.clientName
                            : null,
                        labelText: 'Client',
                        errorText: _selectedPartyId == null ? 'Required' : null,
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, _) => const Text('Error loading clients'),
                    )
                  else if (_selectedPartyType == PartyType.vendor)
                    vendorsAsync.when(
                      data: (vendors) => SearchableDropdown<VendorEntity>(
                        items: vendors,
                        displayStringForOption: (v) => v.vendorName,
                        onSelected: (val) => setState(() => _selectedPartyId = val.id),
                        initialText: _selectedPartyId != null
                            ? vendors
                                  .where((v) => v.id == _selectedPartyId)
                                  .firstOrNull
                                  ?.vendorName
                            : null,
                        labelText: 'Vendor',
                        errorText: _selectedPartyId == null ? 'Required' : null,
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, _) => const Text('Error loading vendors'),
                    ),
                  const SizedBox(height: 16),
                ] else ...[
                  // Read-only display of auto-filled party
                  if (_selectedPartyType == PartyType.client)
                    clientsAsync.when(
                      data: (clients) {
                        final clientName = clients
                            .firstWhere(
                              (c) => c.id == _selectedPartyId,
                              orElse: () => clients.first,
                            )
                            .clientName;
                        return TextFormField(
                          initialValue: clientName,
                          decoration: const InputDecoration(
                            labelText: 'Client',
                          ),
                          readOnly: true,
                          enabled: false,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, _) => const Text('Error loading client'),
                    )
                  else if (_selectedPartyType == PartyType.vendor)
                    vendorsAsync.when(
                      data: (vendors) {
                        final vendorName = vendors
                            .firstWhere(
                              (v) => v.id == _selectedPartyId,
                              orElse: () => vendors.first,
                            )
                            .vendorName;
                        return TextFormField(
                          initialValue: vendorName,
                          decoration: const InputDecoration(
                            labelText: 'Vendor',
                          ),
                          readOnly: true,
                          enabled: false,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, _) => const Text('Error loading vendor'),
                    ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 16),

                // Entry Type
                DropdownButtonFormField<EntryType>(
                  initialValue: _selectedEntryType,
                  decoration: const InputDecoration(labelText: 'Entry Type'),
                  items: EntryType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedEntryType = val!),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _entryTypeHint(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Invoice Number hidden from UI
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) return 'Invalid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Remarks
                TextFormField(
                  controller: _remarksController,
                  decoration: const InputDecoration(
                    labelText: 'Remarks (Optional)',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final entry = LedgerEntity(
                id: 0,
                partyType: _selectedPartyType!,
                partyId: _selectedPartyId!,
                invoiceNumber: '', // pass empty string
                entryType: _selectedEntryType,
                amount: double.parse(_amountController.text),
                entryDate: _selectedDate,
                remarks: _remarksController.text,
                createdAt: DateTime.now(),
              );

              try {
                await ref.read(addEntryProvider(entry).future);
                if (context.mounted) {
                  ref.invalidate(getAllEntriesProvider);
                  ref.invalidate(getBalanceProvider);
                  ref.invalidate(getEntriesByPartyProvider);
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            }
          },
          child: const Text('Add Entry'),
        ),
      ],
    );
  }

  String _entryTypeHint() {
    if (_selectedPartyType == PartyType.client) {
      return 'Client Credit = money received, Client Debit = order/charge added.';
    }

    if (_selectedPartyType == PartyType.vendor) {
      return 'Vendor Credit = amount we owe vendor, Vendor Debit = payment made.';
    }

    return 'Select a party type to see how Credit/Debit affects the balance.';
  }

  EntryType _defaultEntryTypeForParty(PartyType? partyType) {
    if (partyType == PartyType.vendor) {
      return EntryType.debit;
    }

    return EntryType.credit;
  }
}
