import 'dart:math';
import 'entities/payroll_row_entity.dart';

class PayrollCalc {
  /// Recomputes all derived values for a single row mirroring the Postgres trigger
  static PayrollRowEntity recompute(PayrollRowEntity row) {
    final overrides = row.overrides;

    // 1. Salary = Days * Per Day (or override)
    final double salary;
    if (overrides.containsKey('salary') && overrides['salary'] != null) {
      salary = (overrides['salary'] as num).toDouble();
    } else {
      salary = double.parse((row.days * row.perDay).toStringAsFixed(2));
    }

    // 2. Current = Salary - Advance (or override)
    final double currentAmt;
    if (overrides.containsKey('current') && overrides['current'] != null) {
      currentAmt = (overrides['current'] as num).toDouble();
    } else {
      currentAmt = double.parse((salary - row.advance).toStringAsFixed(2));
    }

    // 3. Payable = min(Demand, Current) (or override)
    final double payable;
    if (overrides.containsKey('payable') && overrides['payable'] != null) {
      payable = (overrides['payable'] as num).toDouble();
    } else {
      // Default auto calculation: least(demand, current_amt)
      payable = double.parse(min(row.demand, currentAmt).toStringAsFixed(2));
    }

    // 4. Total = Payable + Overtime (or override)
    final double total;
    if (overrides.containsKey('total') && overrides['total'] != null) {
      total = (overrides['total'] as num).toDouble();
    } else {
      total = double.parse((payable + row.overtime).toStringAsFixed(2));
    }

    return row.copyWith(
      salary: salary,
      currentAmt: currentAmt,
      payable: payable,
      total: total,
    );
  }

  /// Recomputes all derived values for an Overtime sheet row
  static PayrollRowEntity recomputeOvertime(PayrollRowEntity row) {
    final overrides = row.overrides;

    // Hourly rate = perDay / 8
    final hourlyRate = row.perDay > 0 ? (row.perDay / 8.0) : 0.0;
    final dayAmount = double.parse((row.days * row.perDay).toStringAsFixed(2));
    final hourAmount = double.parse((row.hours * hourlyRate).toStringAsFixed(2));
    final calculatedTotal = double.parse((dayAmount + hourAmount).toStringAsFixed(2));

    final double total;
    if (overrides.containsKey('payable') && overrides['payable'] != null) {
      total = (overrides['payable'] as num).toDouble();
    } else if (overrides.containsKey('paid_amount') && overrides['paid_amount'] != null) {
      total = (overrides['paid_amount'] as num).toDouble();
    } else if (overrides.containsKey('total') && overrides['total'] != null) {
      total = (overrides['total'] as num).toDouble();
    } else {
      total = calculatedTotal;
    }

    return row.copyWith(
      salary: dayAmount,
      overtime: hourAmount,
      currentAmt: total,
      payable: total,
      total: total,
    );
  }
}
