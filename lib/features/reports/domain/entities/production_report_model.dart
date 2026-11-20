class ProductionReportItem {
  final int productId;
  final String productName;
  final double quantity;
  final double unitWeight;
  final double totalWeight; // quantity * unitWeight
  final double basePrice;
  final double productionValue; // quantity * basePrice

  const ProductionReportItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitWeight,
    required this.totalWeight,
    required this.basePrice,
    required this.productionValue,
  });
}

class ProductionReportModel {
  final List<ProductionReportItem> items;
  final double totalQuantity;
  final double totalWeight; // kg
  final double totalProductionValue; // Rs.

  const ProductionReportModel({
    required this.items,
    required this.totalQuantity,
    required this.totalWeight,
    required this.totalProductionValue,
  });

  factory ProductionReportModel.empty() {
    return const ProductionReportModel(
      items: [],
      totalQuantity: 0.0,
      totalWeight: 0.0,
      totalProductionValue: 0.0,
    );
  }
}
