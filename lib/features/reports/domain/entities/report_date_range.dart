import 'package:intl/intl.dart';

enum DateRangePreset {
  thisMonth,
  lastMonth,
  last30Days,
  thisQuarter,
  custom,
}

class ReportDateRange {
  final DateTime startDate;
  final DateTime endDate;
  final DateRangePreset preset;

  const ReportDateRange({
    required this.startDate,
    required this.endDate,
    this.preset = DateRangePreset.thisMonth,
  });

  /// Factory for the default: 1st of current month to end of current month
  factory ReportDateRange.currentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1, 0, 0, 0);
    // Last millisecond of the month
    final nextMonthFirst = DateTime(now.year, now.month + 1, 1, 0, 0, 0);
    final end = nextMonthFirst.subtract(const Duration(seconds: 1));
    return ReportDateRange(
      startDate: start,
      endDate: end,
      preset: DateRangePreset.thisMonth,
    );
  }

  /// Factory for previous month
  factory ReportDateRange.lastMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, 1, 0, 0, 0);
    final end = DateTime(now.year, now.month, 1, 0, 0, 0)
        .subtract(const Duration(seconds: 1));
    return ReportDateRange(
      startDate: start,
      endDate: end,
      preset: DateRangePreset.lastMonth,
    );
  }

  /// Factory for last 30 days
  factory ReportDateRange.last30Days() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final start = end
        .subtract(const Duration(days: 30))
        .copyWith(hour: 0, minute: 0, second: 0);
    return ReportDateRange(
      startDate: start,
      endDate: end,
      preset: DateRangePreset.last30Days,
    );
  }

  /// Factory for this quarter
  factory ReportDateRange.thisQuarter() {
    final now = DateTime.now();
    final quarterMonth = ((now.month - 1) ~/ 3) * 3 + 1;
    final start = DateTime(now.year, quarterMonth, 1, 0, 0, 0);
    final end = DateTime(now.year, quarterMonth + 3, 1, 0, 0, 0)
        .subtract(const Duration(seconds: 1));
    return ReportDateRange(
      startDate: start,
      endDate: end,
      preset: DateRangePreset.thisQuarter,
    );
  }

  /// Factory for custom range
  factory ReportDateRange.custom(DateTime start, DateTime end) {
    return ReportDateRange(
      startDate: DateTime(start.year, start.month, start.day, 0, 0, 0),
      endDate: DateTime(end.year, end.month, end.day, 23, 59, 59),
      preset: DateRangePreset.custom,
    );
  }

  String get label {
    final startFmt = DateFormat('MMM dd, yyyy').format(startDate);
    final endFmt = DateFormat('MMM dd, yyyy').format(endDate);
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == 1 &&
        endDate.day ==
            DateTime(endDate.year, endDate.month + 1, 0).day) {
      return DateFormat('MMMM yyyy').format(startDate);
    }
    return '$startFmt - $endFmt';
  }

  ReportDateRange copyWith({
    DateTime? startDate,
    DateTime? endDate,
    DateRangePreset? preset,
  }) {
    return ReportDateRange(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      preset: preset ?? this.preset,
    );
  }
}
