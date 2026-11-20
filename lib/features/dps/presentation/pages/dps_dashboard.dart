import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/features/dps/domain/entities/dps_models.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import '../providers/dps_providers.dart';
import 'add_dps_report_page.dart';
import 'dps_report_details_page.dart';

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

  Future<void> _openReportDetails(DpsReport report) async {
    // Details + editing now happen in a modal dialog rather than a full
    // page push — keeps the user anchored on the list behind it.
    final changed = await DpsReportDetailsDialog.show(context, report);
    if (changed == true) {
      ref.invalidate(dpsReportsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(dpsReportsProvider);

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        backgroundColor: AppColors.textWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Production Reports',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase()),
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search reports...',
                  hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 15),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textGrey,
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ── List ─────────────────────────────────────────────────────
          Expanded(
            child: reportsAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: AppColors.errorText),
                ),
              ),
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
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 40,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          reports.isEmpty
                              ? 'No reports yet. Tap "Add Report" to create one.'
                              : 'No reports match your search.',
                          style: TextStyle(color: AppColors.textGrey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(top: 4, bottom: 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.dividerColor,
                  ),
                  itemBuilder: (_, i) => _ReportTile(
                    report: filtered[i],
                    onTap: () => _openReportDetails(filtered[i]),
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
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Report',
          style: TextStyle(fontWeight: FontWeight.w600),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textBlack87,
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: AppColors.textGrey),
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
                  bgColor: AppColors.iconBackground,
                  iconColor: AppColors.iconColor,
                  textColor: AppColors.indicatorText,
                ),
                if (report.notes != null && report.notes!.isNotEmpty)
                  _InfoChip(
                    icon: Icons.notes_rounded,
                    label: report.notes!.length > 24
                        ? '${report.notes!.substring(0, 24)}…'
                        : report.notes!,
                    bgColor: AppColors.badgeBackground,
                    iconColor: AppColors.textGrey,
                    textColor: AppColors.textBlack87,
                  ),
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: DateFormat('EEE').format(report.reportDate),
                  bgColor: AppColors.totalSummaryBackground,
                  iconColor: AppColors.successText,
                  textColor: AppColors.successText,
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
