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
}
