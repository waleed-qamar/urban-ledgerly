import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_review_providers.dart';

class DateRangeFilterBar extends ConsumerWidget {
  const DateRangeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(attendanceReviewFilterProvider);
    final notifier = ref.read(attendanceReviewFilterProvider.notifier);
    final dateFormat = DateFormat('MMM d, yyyy');

    final now = DateTime.now();
    final thisMonday = _weekStart(now);
    final lastMonday = thisMonday.subtract(const Duration(days: 7));
    final thisMondaySunday = thisMonday.add(const Duration(days: 6));
    final lastMondaySunday = lastMonday.add(const Duration(days: 6));

    final isCurrentWeek = filter.from == thisMonday &&
        filter.to == thisMondaySunday;
    final isLastWeek = filter.from == lastMonday &&
        filter.to == lastMondaySunday;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Period:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(width: 12),

          // This Week preset
          _PresetChip(
            label: 'This Week',
            selected: isCurrentWeek,
            onTap: notifier.setCurrentWeek,
          ),
          const SizedBox(width: 8),

          // Last Week preset
          _PresetChip(
            label: 'Last Week',
            selected: isLastWeek,
            onTap: notifier.setLastWeek,
          ),
          const SizedBox(width: 8),

          // Custom date range picker
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: (!isCurrentWeek && !isLastWeek)
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade400,
              ),
              foregroundColor: (!isCurrentWeek && !isLastWeek)
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
            ),
            icon: const Icon(Icons.date_range, size: 16),
            label: Text(
              (!isCurrentWeek && !isLastWeek)
                  ? '${dateFormat.format(filter.from)} – ${dateFormat.format(filter.to)}'
                  : 'Custom',
              style: const TextStyle(fontSize: 13),
            ),
            onPressed: () async {
              final result = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDateRange:
                    DateTimeRange(start: filter.from, end: filter.to),
                builder: (context, child) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: SizedBox(
                      width: 780,
                      height: 600,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: child!,
                      ),
                    ),
                  );
                },
              );
              if (result != null) {
                notifier.setDateRange(result.start, result.end);
              }
            },
          ),

          const Spacer(),

          // Range display text
          Text(
            '${dateFormat.format(filter.from)} – ${dateFormat.format(filter.to)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  DateTime _weekStart(DateTime date) {
    final daysFromMonday = (date.weekday - 1) % 7;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
