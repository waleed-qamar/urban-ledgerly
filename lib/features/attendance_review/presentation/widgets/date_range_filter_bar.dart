import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_review_providers.dart';

class DateRangeFilterBar extends ConsumerWidget {
  const DateRangeFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(attendanceReviewFilterProvider);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          const Text('Date Range:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text('${dateFormat.format(filter.from)} - ${dateFormat.format(filter.to)}'),
            onPressed: () async {
              final result = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                initialDateRange: DateTimeRange(start: filter.from, end: filter.to),
              );

              if (result != null) {
                ref.read(attendanceReviewFilterProvider.notifier).setDateRange(result.start, result.end);
              }
            },
          ),
        ],
      ),
    );
  }
}
