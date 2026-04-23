import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ledger_entity.dart';
import '../providers/ledger_providers.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../vender/presentation/providers/vendor_providers.dart';
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
                // Party Type Selector
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
                    });
                  },
                  validator: (val) => val == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Party Selector
                if (_selectedPartyType == PartyType.client)
                  clientsAsync.when(
                    data: (clients) => DropdownButtonFormField<int>(
                      value: _selectedPartyId,
                      decoration: const InputDecoration(labelText: 'Client'),
                      items: clients.map((c) {
                        return DropdownMenuItem(
                          value: c.id,
                          child: Text(c.clientName),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedPartyId = val),
                      validator: (val) => val == null ? 'Required' : null,
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text('Error loading clients'),
                  )
                else if (_selectedPartyType == PartyType.vendor)
                  vendorsAsync.when(
                    data: (vendors) => DropdownButtonFormField<int>(
                      value: _selectedPartyId,
                      decoration: const InputDecoration(labelText: 'Vendor'),
                      items: vendors.map((v) {
                        return DropdownMenuItem(
                          value: v.id,
                          child: Text(v.vendorName),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedPartyId = val),
                      validator: (val) => val == null ? 'Required' : null,
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text('Error loading vendors'),
                  ),

                const SizedBox(height: 16),

                // Entry Type
                DropdownButtonFormField<EntryType>(
                  value: _selectedEntryType,
                  decoration: const InputDecoration(labelText: 'Entry Type'),
                  items: EntryType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedEntryType = val!),
                ),
                const SizedBox(height: 16),

                // Invoice Number
                TextFormField(
                  controller: _invoiceNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Invoice Number',
                    hintText: 'Enter invoice number',
                  ),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) return 'Invalid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
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
                id: DateTime.now()
                    .microsecondsSinceEpoch, // Supabase will assign
                partyType: _selectedPartyType!,
                partyId: _selectedPartyId!,
                invoiceNumber: _invoiceNumberController.text,
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
}
