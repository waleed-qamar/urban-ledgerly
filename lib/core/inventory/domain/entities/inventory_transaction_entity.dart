/// Represents a single row in the unified `inventory_transactions` table.
///
/// Both products and raw materials share this entity — the [itemType] field
/// ('PRODUCT' or 'RAW_MATERIAL') discriminates between them.
///
/// The optional [referenceType] / [referenceId] fields allow future modules
/// (Procurement, Invoices, BOM, Production) to link transactions without
/// changing this schema.
class InventoryTransactionEntity {
  final int id;

  /// The PK of the item in its own table (products.id or raw_material.id).
  final int itemId;

  /// 'PRODUCT' or 'RAW_MATERIAL'
  final String itemType;

  /// 'IN' or 'OUT'
  final String transactionType;

  final int quantity;

  /// Optional: 'SALE', 'PROCUREMENT', 'PRODUCTION', 'INVOICE', 'BOM'
  final String? referenceType;

  /// FK to the referenced document (invoice id, bom id, etc.)
  final int? referenceId;

  final String? notes;

  final DateTime createdAt;

  const InventoryTransactionEntity({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.transactionType,
    required this.quantity,
    this.referenceType,
    this.referenceId,
    this.notes,
    required this.createdAt,
  });

  factory InventoryTransactionEntity.fromJson(Map<String, dynamic> json) {
    return InventoryTransactionEntity(
      id: json['id'] as int,
      itemId: json['item_id'] as int,
      itemType: json['item_type'] as String,
      transactionType: json['transaction_type'] as String,
      quantity: json['quantity'] as int,
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as int?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': itemId,
      'item_type': itemType,
      'transaction_type': transactionType,
      'quantity': quantity,
      'reference_type': referenceType,
      'reference_id': referenceId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isIn => transactionType.toUpperCase() == 'IN';
}
