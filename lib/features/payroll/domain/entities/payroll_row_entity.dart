class PayrollRowEntity {
  final String id;
  final String sheetId;
  final int employeeId;
  final String nameSnapshot;
  final int sortOrder;

  // Editable input values
  final double days;
  final double hours;
  final double perDay;
  final double advance;
  final double demand;
  final double overtime;

  // Overrides map (e.g. {'payable': 25000})
  final Map<String, dynamic> overrides;

  // Derived values computed by trigger or local calc
  final double salary;
  final double currentAmt;
  final double payable;
  final double total;

  final int version;
  final DateTime? updatedAt;

  const PayrollRowEntity({
    required this.id,
    required this.sheetId,
    required this.employeeId,
    required this.nameSnapshot,
    this.sortOrder = 0,
    this.days = 0.0,
    this.hours = 0.0,
    this.perDay = 0.0,
    this.advance = 0.0,
    this.demand = 0.0,
    this.overtime = 0.0,
    this.overrides = const {},
    this.salary = 0.0,
    this.currentAmt = 0.0,
    this.payable = 0.0,
    this.total = 0.0,
    this.version = 1,
    this.updatedAt,
  });

  bool get isPayableOverridden => overrides.containsKey('payable') || overrides.containsKey('paid_amount');
  bool get isSalaryOverridden => overrides.containsKey('salary');
  bool get isCurrentOverridden => overrides.containsKey('current');
  bool get isTotalOverridden => overrides.containsKey('total');

  // Overtime Derived Helpers
  double get hourlyRate => perDay > 0 ? (perDay / 8.0) : 0.0;
  double get dayAmount => double.parse((days * perDay).toStringAsFixed(2));
  double get hourAmount => double.parse((hours * hourlyRate).toStringAsFixed(2));
  double get overtimeTotal => double.parse((dayAmount + hourAmount).toStringAsFixed(2));
  double get paidAmount {
    if (overrides.containsKey('payable') && overrides['payable'] != null) {
      return (overrides['payable'] as num).toDouble();
    }
    if (overrides.containsKey('paid_amount') && overrides['paid_amount'] != null) {
      return (overrides['paid_amount'] as num).toDouble();
    }
    return total > 0 ? total : overtimeTotal;
  }
  String get remarks => (total > 0 || overtimeTotal > 0 || paidAmount > 0) ? 'Paid' : 'Zero';
  bool get isZero => (total == 0 && overtimeTotal == 0 && paidAmount == 0);

  factory PayrollRowEntity.fromJson(Map<String, dynamic> json) {
    final overridesMap = json['overrides'] is Map
        ? Map<String, dynamic>.from(json['overrides'] as Map)
        : <String, dynamic>{};

    final rawHours = (json['hours'] as num?)?.toDouble() ??
        (overridesMap['hours'] is num ? (overridesMap['hours'] as num).toDouble() : 0.0);

    return PayrollRowEntity(
      id: json['id'] as String,
      sheetId: json['sheet_id'] as String,
      employeeId: (json['employee_id'] as num).toInt(),
      nameSnapshot: json['name_snapshot'] as String? ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      days: (json['days'] as num?)?.toDouble() ?? 0.0,
      hours: rawHours,
      perDay: (json['per_day'] as num?)?.toDouble() ?? 0.0,
      advance: (json['advance'] as num?)?.toDouble() ?? 0.0,
      demand: (json['demand'] as num?)?.toDouble() ?? 0.0,
      overtime: (json['overtime'] as num?)?.toDouble() ?? 0.0,
      overrides: overridesMap,
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
      currentAmt: (json['current_amt'] as num?)?.toDouble() ?? 0.0,
      payable: (json['payable'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      version: (json['version'] as num?)?.toInt() ?? 1,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sheet_id': sheetId,
      'employee_id': employeeId,
      'name_snapshot': nameSnapshot,
      'sort_order': sortOrder,
      'days': days,
      'hours': hours,
      'per_day': perDay,
      'advance': advance,
      'demand': demand,
      'overtime': overtime,
      'overrides': overrides,
      'salary': salary,
      'current_amt': currentAmt,
      'payable': payable,
      'total': total,
      'version': version,
    };
  }

  /// Produces the minimal patch map for sending updates to Supabase
  Map<String, dynamic> toPatchJson() {
    return {
      'days': days,
      'hours': hours,
      'per_day': perDay,
      'advance': advance,
      'demand': demand,
      'overtime': overtime,
      'overrides': overrides,
      'salary': salary,
      'current_amt': currentAmt,
      'payable': payable,
      'total': total,
    };
  }

  PayrollRowEntity copyWith({
    String? id,
    String? sheetId,
    int? employeeId,
    String? nameSnapshot,
    int? sortOrder,
    double? days,
    double? hours,
    double? perDay,
    double? advance,
    double? demand,
    double? overtime,
    Map<String, dynamic>? overrides,
    double? salary,
    double? currentAmt,
    double? payable,
    double? total,
    int? version,
    DateTime? updatedAt,
  }) {
    return PayrollRowEntity(
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      employeeId: employeeId ?? this.employeeId,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      sortOrder: sortOrder ?? this.sortOrder,
      days: days ?? this.days,
      hours: hours ?? this.hours,
      perDay: perDay ?? this.perDay,
      advance: advance ?? this.advance,
      demand: demand ?? this.demand,
      overtime: overtime ?? this.overtime,
      overrides: overrides ?? this.overrides,
      salary: salary ?? this.salary,
      currentAmt: currentAmt ?? this.currentAmt,
      payable: payable ?? this.payable,
      total: total ?? this.total,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
