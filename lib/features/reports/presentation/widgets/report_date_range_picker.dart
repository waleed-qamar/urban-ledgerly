import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/report_date_range.dart';
import '../providers/reports_filter_provider.dart';

class ReportDateRangePicker extends ConsumerWidget {
  const ReportDateRangePicker({super.key});

  Future<void> _pickCustomRange(BuildContext context, WidgetRef ref) async {
    final current = ref.read(reportDateRangeProvider);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDateRange: DateTimeRange(
        start: current.startDate,
        end: current.endDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(reportDateRangeProvider.notifier).setCustomRange(
            picked.start,
            picked.end,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRange = ref.watch(reportDateRangeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Selected Date Range Display Button
          InkWell(
            onTap: () => _pickCustomRange(context, ref),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.date_range, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    currentRange.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 18),
                ],
              ),
            ),
          ),

          // Preset Chips
          Wrap(
            spacing: 8,
            children: [
              _buildPresetChip(
                ref: ref,
                label: 'This Month',
                preset: DateRangePreset.thisMonth,
                isSelected: currentRange.preset == DateRangePreset.thisMonth,
              ),
              _buildPresetChip(
                ref: ref,
                label: 'Last Month',
                preset: DateRangePreset.lastMonth,
                isSelected: currentRange.preset == DateRangePreset.lastMonth,
              ),
              _buildPresetChip(
                ref: ref,
                label: 'Last 30 Days',
                preset: DateRangePreset.last30Days,
                isSelected: currentRange.preset == DateRangePreset.last30Days,
              ),
              _buildPresetChip(
                ref: ref,
                label: 'This Quarter',
                preset: DateRangePreset.thisQuarter,
                isSelected: currentRange.preset == DateRangePreset.thisQuarter,
              ),
              _buildPresetChip(
                ref: ref,
                label: 'Custom Range',
                preset: DateRangePreset.custom,
                isSelected: currentRange.preset == DateRangePreset.custom,
                onTap: () => _pickCustomRange(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip({
    required WidgetRef ref,
    required String label,
    required DateRangePreset preset,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : Colors.grey.shade300,
      ),
      onSelected: (_) {
        if (onTap != null) {
          onTap();
        } else {
          ref.read(reportDateRangeProvider.notifier).setPreset(preset);
        }
      },
    );
  }
}
