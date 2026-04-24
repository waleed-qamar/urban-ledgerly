import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../client/presentation/providers/client_providers.dart';
import '../../../vender/presentation/providers/vendor_providers.dart';
import '../../../client/domain/entities/client_entity.dart';
import '../../../vender/domain/entities/vendor_entity.dart';
import '../../domain/entities/ledger_entity.dart';
import '../providers/ledger_providers.dart';
import '../widgets/add_ledger_entry_dialog.dart';
import 'ledger_details_page.dart';

enum LedgerFilter { all, clients, vendors }

class LedgerPage extends ConsumerStatefulWidget {
  const LedgerPage({super.key});

  @override
  ConsumerState<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends ConsumerState<LedgerPage> {
  LedgerFilter _filter = LedgerFilter.all;

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(getAllClientsProvider);
    final vendorsAsync = ref.watch(getAllvendorsProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ledger',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                // ElevatedButton.icon(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.primary,
                //     foregroundColor: AppColors.textWhite,
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 24,
                //       vertical: 18,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) => const AddLedgerEntryDialog(),
                //     );
                //   },
                //   icon: const Icon(Icons.add),
                //   label: const Text('Add Entry'),
                // ),
              ],
            ),
            const SizedBox(height: 32),

            // Summary Cards (Optional, like in Vendor view)
            // For now, focusing on the list as requested.

            // Filters
            Row(
              children: [
                _buildFilterPill(
                  'All',
                  isSelected: _filter == LedgerFilter.all,
                  onTap: () => setState(() => _filter = LedgerFilter.all),
                ),
                const SizedBox(width: 12),
                _buildFilterPill(
                  'Clients',
                  isSelected: _filter == LedgerFilter.clients,
                  onTap: () => setState(() => _filter = LedgerFilter.clients),
                ),
                const SizedBox(width: 12),
                _buildFilterPill(
                  'Vendors',
                  isSelected: _filter == LedgerFilter.vendors,
                  onTap: () => setState(() => _filter = LedgerFilter.vendors),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Combined List
            Expanded(child: _buildCombinedList(clientsAsync, vendorsAsync)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.badgeBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: AppColors.dividerColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.textBlack : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedList(
    AsyncValue<List<ClientEntity>> clientsAsync,
    AsyncValue<List<VendorEntity>> vendorsAsync,
  ) {
    if (clientsAsync.isLoading || vendorsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (clientsAsync.hasError || vendorsAsync.hasError) {
      return Center(
        child: Text(
          'Error loading data: ${clientsAsync.error ?? vendorsAsync.error}',
        ),
      );
    }

    final clients = clientsAsync.value ?? [];
    final vendors = vendorsAsync.value ?? [];

    final List<_PartyListItem> items = [];

    if (_filter == LedgerFilter.all || _filter == LedgerFilter.clients) {
      items.addAll(
        clients.map<_PartyListItem>(
          (c) => _PartyListItem(
            id: c.id,
            name: c.clientName,
            type: PartyType.client,
            subtitle: c.contactNumber,
          ),
        ),
      );
    }

    if (_filter == LedgerFilter.all || _filter == LedgerFilter.vendors) {
      items.addAll(
        vendors.map<_PartyListItem>(
          (v) => _PartyListItem(
            id: v.id,
            name: v.vendorName,
            type: PartyType.vendor,
            subtitle: v.vendorNotes.isNotEmpty ? v.vendorNotes : v.companyName,
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No parties found matching the filter.',
          style: TextStyle(color: AppColors.textGrey),
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return _PartyTile(item: item);
      },
    );
  }
}

class _PartyListItem {
  final int id;
  final String name;
  final PartyType type;
  final String subtitle;

  _PartyListItem({
    required this.id,
    required this.name,
    required this.type,
    required this.subtitle,
  });
}

class _PartyTile extends ConsumerWidget {
  final _PartyListItem item;

  const _PartyTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(
      getBalanceProvider(partyType: item.type, partyId: item.id),
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LedgerDetailsPage(
              partyId: item.id,
              partyType: item.type,
              partyName: item.name,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.dividerColor.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textGrey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightBackground,
              child: Icon(
                item.type == PartyType.client ? Icons.person : Icons.business,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddLedgerEntryDialog(
                          initialPartyType: item.type,
                          initialPartyId: item.id,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Entry'),
                  ),
                  SizedBox(width: 48),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Balance',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        item.type == PartyType.client
                            ? 'Client owes you'
                            : 'You owe vendor',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 11,
                        ),
                      ),
                      balanceAsync.when(
                        data: (balance) => Text(
                          balance.abs().toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _balanceColorForParty(partyType: item.type),
                          ),
                        ),
                        loading: () => const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, _) => const Text(
                          'Error',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.chevron_right, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  static Color _balanceColorForParty({required PartyType partyType}) {
    return partyType == PartyType.client
        ? AppColors.successText
        : AppColors.errorText;
  }
}
