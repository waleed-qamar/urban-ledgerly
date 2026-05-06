import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/features/dps/domain/entities/dps_models.dart';
import '../providers/dps_providers.dart';
import 'add_dps_report_page.dart';
import 'dps_report_details_page.dart';
import 'dps_summary_page.dart';

class DpsDashboard extends ConsumerStatefulWidget {
  const DpsDashboard({super.key});

  @override
  ConsumerState<DpsDashboard> createState() => _DpsDashboardState();
}

class _DpsDashboardState extends ConsumerState<DpsDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(dpsReportsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Production Reports',
          style: TextStyle(
            color: Color(0xFF6B6BF0),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded, color: Colors.black54),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DpsSummaryPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase()),
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Search reports...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ── List ─────────────────────────────────────────────────────
          Expanded(
            child: reportsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (reports) {
                final filtered = _searchQuery.isEmpty
                    ? reports
                    : reports.where((r) {
                        final label = DateFormat(
                          'MMMM d, yyyy',
                        ).format(r.reportDate).toLowerCase();
                        return label.contains(_searchQuery) ||
                            (r.notes?.toLowerCase().contains(_searchQuery) ??
                                false);
                      }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reports found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(top: 4, bottom: 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Color(0xFFEEEEEE),
                  ),
                  itemBuilder: (_, i) => _ReportTile(
                    report: filtered[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DpsReportDetailsPage(report: filtered[i]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ── FAB ────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddDpsReportPage()),
          );
          if (added == true) ref.invalidate(dpsReportsProvider);
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Report',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ReportTile extends StatelessWidget {
  final DpsReport report;
  final VoidCallback onTap;

  const _ReportTile({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('MMMM d, yyyy').format(report.reportDate);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const Icon(Icons.more_vert, size: 20, color: Colors.black38),
              ],
            ),

            const SizedBox(height: 10),

            // ── Info chips ──────────────────────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _InfoChip(
                  icon: Icons.precision_manufacturing_outlined,
                  label: 'Report #${report.id ?? '—'}',
                  bgColor: const Color(0xFFEDE9FE),
                  iconColor: const Color(0xFF7C3AED),
                  textColor: const Color(0xFF5B21B6),
                ),
                if (report.notes != null && report.notes!.isNotEmpty)
                  _InfoChip(
                    icon: Icons.notes_rounded,
                    label: report.notes!.length > 24
                        ? '${report.notes!.substring(0, 24)}…'
                        : report.notes!,
                    bgColor: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0284C7),
                    textColor: const Color(0xFF0369A1),
                  ),
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: DateFormat('EEE').format(report.reportDate),
                  bgColor: const Color(0xFFF0FDF4),
                  iconColor: const Color(0xFF16A34A),
                  textColor: const Color(0xFF15803D),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final Color textColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
