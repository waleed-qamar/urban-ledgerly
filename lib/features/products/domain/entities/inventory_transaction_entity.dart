class InventoryTransactionEntity {
  final int id;
  final int productId;
  final String transactionType;
  final int quantity;
  final DateTime createdAt;

  const InventoryTransactionEntity({
    required this.id,
    required this.productId,
    required this.transactionType,
    required this.quantity,
    required this.createdAt,
  });

  factory InventoryTransactionEntity.fromJson(Map<String, dynamic> json) {
    return InventoryTransactionEntity(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      transactionType: json['transaction_type'] as String,
      quantity: json['quantity'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'transaction_type': transactionType,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isIn => transactionType.toUpperCase() == 'IN';
}
