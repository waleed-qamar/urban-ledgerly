import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/report_date_range.dart';

class ReportDateRangeNotifier extends Notifier<ReportDateRange> {
  @override
  ReportDateRange build() {
    return ReportDateRange.currentMonth();
  }

  void setPreset(DateRangePreset preset) {
    switch (preset) {
      case DateRangePreset.thisMonth:
        state = ReportDateRange.currentMonth();
        break;
      case DateRangePreset.lastMonth:
        state = ReportDateRange.lastMonth();
        break;
      case DateRangePreset.last30Days:
        state = ReportDateRange.last30Days();
        break;
      case DateRangePreset.thisQuarter:
        state = ReportDateRange.thisQuarter();
        break;
      case DateRangePreset.custom:
        break;
    }
  }

  void setCustomRange(DateTime start, DateTime end) {
    state = ReportDateRange.custom(start, end);
  }
}

final reportDateRangeProvider =
    NotifierProvider<ReportDateRangeNotifier, ReportDateRange>(() {
  return ReportDateRangeNotifier();
});
