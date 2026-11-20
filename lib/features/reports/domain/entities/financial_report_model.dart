class FinancialReportModel {
  final double monthlySale; // Total sales in Rs.
  final double monthlyRecovery; // Total recoveries/receipts in Rs.
  final double monthlyProduction; // Total production value (base price x qty)

  const FinancialReportModel({
    required this.monthlySale,
    required this.monthlyRecovery,
    required this.monthlyProduction,
  });

  factory FinancialReportModel.empty() {
    return const FinancialReportModel(
      monthlySale: 0.0,
      monthlyRecovery: 0.0,
      monthlyProduction: 0.0,
    );
  }
}
