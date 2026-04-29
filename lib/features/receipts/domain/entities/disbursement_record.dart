class DisbursementRecord {
  final int id;
  final int supplierId;
  final String disbursementNumber;
  final double totalAmount;
  final String paymentMethod;
  final String? accountNo;
  final String? category;
  final String? remarks;
  final DateTime paidDate;
  final DateTime createdAt;

  const DisbursementRecord({
    required this.id,
    required this.supplierId,
    required this.disbursementNumber,
    required this.totalAmount,
    required this.paymentMethod,
    required this.accountNo,
    required this.category,
    required this.remarks,
    required this.paidDate,
    required this.createdAt,
  });

  factory DisbursementRecord.fromJson(Map<String, dynamic> json) {
    return DisbursementRecord(
      id: (json['id'] as num?)?.toInt() ?? 0,
      supplierId: _asInt(json['supplierId'] ?? json['supplier_id']),
      disbursementNumber:
          (json['disbursementNumber'] ?? json['disbursement_number'] ?? '')
              .toString(),
      totalAmount: (json['totalAmount'] ?? json['total_amount'] ?? 0)
          .toDouble(),
      paymentMethod: (json['paymentMethod'] ?? json['payment_method'] ?? '')
          .toString(),
      accountNo: (json['accountNo'] ?? json['account_no'])?.toString(),
      category: (json['category'])?.toString(),
      remarks: (json['remarks'])?.toString(),
      paidDate:
          DateTime.tryParse(
            (json['paidDate'] ??
                    json['paid_date'] ??
                    DateTime.now().toIso8601String())
                .toString(),
          ) ??
          DateTime.now(),
      createdAt:
          DateTime.tryParse(
            (json['createdAt'] ??
                    json['created_at'] ??
                    DateTime.now().toIso8601String())
                .toString(),
          ) ??
          DateTime.now(),
    );
  }

  static int _asInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
