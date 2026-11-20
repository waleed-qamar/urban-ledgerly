class ExpenseItemDetail {
  final int expenseHeadId;
  final String expenseHeadName;
  final double amount;

  const ExpenseItemDetail({
    required this.expenseHeadId,
    required this.expenseHeadName,
    required this.amount,
  });
}

class ExpenditureCategoryDetail {
  final String categoryName;
  final double totalAmount;
  final double costPerKg;
  final List<ExpenseItemDetail> subHeads;

  const ExpenditureCategoryDetail({
    required this.categoryName,
    required this.totalAmount,
    required this.costPerKg,
    required this.subHeads,
  });
}

class ProductionExpenditureModel {
  final double totalWeight; // from DPS production logs in kg
  final ExpenditureCategoryDetail pureProduction;
  final ExpenditureCategoryDetail managementOverhead;
  final ExpenditureCategoryDetail maintenanceOverhead;
  final ExpenditureCategoryDetail saleOverhead;
  final ExpenditureCategoryDetail factoryOverhead;
  final double totalExpenditure; // Sum of the 5 categories
  final double totalCostPerKg;

  // Breakdown summary
  final double pureProductionCostPerKg;
  final double overheadsCostPerKg; // Management + Maintenance + Sale + Factory per kg
  final double grandTotalCostPerKg;

  // Non-production categories from Image 2
  final ExpenditureCategoryDetail vehicles;
  final ExpenditureCategoryDetail domestic;
  final ExpenditureCategoryDetail development;

  const ProductionExpenditureModel({
    required this.totalWeight,
    required this.pureProduction,
    required this.managementOverhead,
    required this.maintenanceOverhead,
    required this.saleOverhead,
    required this.factoryOverhead,
    required this.totalExpenditure,
    required this.totalCostPerKg,
    required this.pureProductionCostPerKg,
    required this.overheadsCostPerKg,
    required this.grandTotalCostPerKg,
    required this.vehicles,
    required this.domestic,
    required this.development,
  });

  factory ProductionExpenditureModel.empty() {
    const emptyCat = ExpenditureCategoryDetail(
      categoryName: '',
      totalAmount: 0.0,
      costPerKg: 0.0,
      subHeads: [],
    );
    return const ProductionExpenditureModel(
      totalWeight: 0.0,
      pureProduction: emptyCat,
      managementOverhead: emptyCat,
      maintenanceOverhead: emptyCat,
      saleOverhead: emptyCat,
      factoryOverhead: emptyCat,
      totalExpenditure: 0.0,
      totalCostPerKg: 0.0,
      pureProductionCostPerKg: 0.0,
      overheadsCostPerKg: 0.0,
      grandTotalCostPerKg: 0.0,
      vehicles: emptyCat,
      domestic: emptyCat,
      development: emptyCat,
    );
  }
}
