class ClosingBalanceItem {
  final String title;
  final double openingBalance;
  final double closingBalance;
  final bool isDeduction;

  const ClosingBalanceItem({
    required this.title,
    required this.openingBalance,
    required this.closingBalance,
    this.isDeduction = false,
  });
}

class MonthlyClosingModel {
  final double rawStockOpening;
  final double rawStockClosing;

  final double finishProductOpening;
  final double finishProductClosing;

  final double recoverableOpening;
  final double recoverableClosing;

  final double cashInHandOpening;
  final double cashInHandClosing;

  final double payablesOpening;
  final double payablesClosing;

  // Balance = Raw + Finish + Recoverable + Cash - Payables
  final double balanceOpening;
  final double balanceClosing;

  // In-period expenditures (deducted in closing)
  final double domesticExpenditure;
  final double productionExpenditure;

  // Total = Balance - Domestic - Production (for closing)
  final double totalOpening;
  final double totalClosing;

  // Value Addition = Total Closing - Total Opening
  final double valueAddition;

  const MonthlyClosingModel({
    required this.rawStockOpening,
    required this.rawStockClosing,
    required this.finishProductOpening,
    required this.finishProductClosing,
    required this.recoverableOpening,
    required this.recoverableClosing,
    required this.cashInHandOpening,
    required this.cashInHandClosing,
    required this.payablesOpening,
    required this.payablesClosing,
    required this.balanceOpening,
    required this.balanceClosing,
    required this.domesticExpenditure,
    required this.productionExpenditure,
    required this.totalOpening,
    required this.totalClosing,
    required this.valueAddition,
  });

  factory MonthlyClosingModel.empty() {
    return const MonthlyClosingModel(
      rawStockOpening: 0.0,
      rawStockClosing: 0.0,
      finishProductOpening: 0.0,
      finishProductClosing: 0.0,
      recoverableOpening: 0.0,
      recoverableClosing: 0.0,
      cashInHandOpening: 0.0,
      cashInHandClosing: 0.0,
      payablesOpening: 0.0,
      payablesClosing: 0.0,
      balanceOpening: 0.0,
      balanceClosing: 0.0,
      domesticExpenditure: 0.0,
      productionExpenditure: 0.0,
      totalOpening: 0.0,
      totalClosing: 0.0,
      valueAddition: 0.0,
    );
  }
}
