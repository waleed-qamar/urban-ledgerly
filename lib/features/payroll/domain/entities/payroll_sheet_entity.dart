class PayrollSheetEntity {
  final String id;
  final String company;
  final String category;
  final String title;
  final DateTime cutoffDate;
  final String status; // 'draft' | 'finalized'
  final String? operatorName;
  final double amountGiven;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PayrollSheetEntity({
    required this.id,
    required this.company,
    required this.category,
    required this.title,
    required this.cutoffDate,
    required this.status,
    this.operatorName,
    this.amountGiven = 0.0,
    this.createdAt,
    this.updatedAt,
  });

  bool get isFinalized => status == 'finalized';
  bool get isDraft => status == 'draft';

  factory PayrollSheetEntity.fromJson(Map<String, dynamic> json) {
    return PayrollSheetEntity(
      id: json['id'] as String,
      company: json['company'] as String? ?? 'Urban Composites/Urban Constructions',
      category: json['category'] as String? ?? 'Labour',
      title: json['title'] as String? ?? '22 Kharcha',
      cutoffDate: DateTime.parse(json['cutoff_date'] as String),
      status: json['status'] as String? ?? 'draft',
      operatorName: json['operator_name'] as String?,
      amountGiven: (json['amount_given'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'category': category,
      'title': title,
      'cutoff_date': cutoffDate.toIso8601String().split('T').first,
      'status': status,
      'operator_name': operatorName,
      'amount_given': amountGiven,
    };
  }

  PayrollSheetEntity copyWith({
    String? id,
    String? company,
    String? category,
    String? title,
    DateTime? cutoffDate,
    String? status,
    String? operatorName,
    double? amountGiven,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PayrollSheetEntity(
      id: id ?? this.id,
      company: company ?? this.company,
      category: category ?? this.category,
      title: title ?? this.title,
      cutoffDate: cutoffDate ?? this.cutoffDate,
      status: status ?? this.status,
      operatorName: operatorName ?? this.operatorName,
      amountGiven: amountGiven ?? this.amountGiven,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
