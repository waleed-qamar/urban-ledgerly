class SaleStockReportItem {
  final int productId;
  final String productName;
  final double openingBalance; // a
  final double produced; // b
  final double sold; // c
  final double stock; // b + a - c
  final double unitPrice;

  const SaleStockReportItem({
    required this.productId,
    required this.productName,
    required this.openingBalance,
    required this.produced,
    required this.sold,
    required this.stock,
    required this.unitPrice,
  });

  double get stockValue => stock * unitPrice;
}

class SaleStockReportModel {
  final List<SaleStockReportItem> items;
  final double totalOpening;
  final double totalProduced;
  final double totalSold;
  final double totalStock;
  final double totalStockValue;

  const SaleStockReportModel({
    required this.items,
    required this.totalOpening,
    required this.totalProduced,
    required this.totalSold,
    required this.totalStock,
    required this.totalStockValue,
  });

  factory SaleStockReportModel.empty() {
    return const SaleStockReportModel(
      items: [],
      totalOpening: 0.0,
      totalProduced: 0.0,
      totalSold: 0.0,
      totalStock: 0.0,
      totalStockValue: 0.0,
    );
  }
}
