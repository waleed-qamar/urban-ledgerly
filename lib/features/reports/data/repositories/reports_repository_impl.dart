import '../datasources/reports_remote_datasource.dart';
import '../../domain/entities/report_date_range.dart';
import '../../domain/entities/financial_report_model.dart';
import '../../domain/entities/production_report_model.dart';
import '../../domain/entities/sale_stock_report_model.dart';
import '../../domain/entities/monthly_closing_model.dart';
import '../../domain/entities/production_expenditure_model.dart';
import '../../domain/repositories/reports_repository.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDatasource _datasource;

  ReportsRepositoryImpl(this._datasource);

  @override
  Future<FinancialReportModel> getFinancialReport(ReportDateRange range) async {
    // 1. Monthly Sale
    final invoices = await _datasource.fetchInvoices(range.startDate, range.endDate);
    double totalSale = 0.0;
    for (final inv in invoices) {
      totalSale += ((inv['grand_total'] as num?)?.toDouble() ?? 0.0);
    }

    // 2. Monthly Recovery
    final receipts = await _datasource.fetchReceipts(range.startDate, range.endDate);
    double totalRecovery = 0.0;
    for (final rec in receipts) {
      totalRecovery += ((rec['total_amount'] as num?)?.toDouble() ?? 0.0);
    }

    // 3. Monthly Production Value (base price x qty produced)
    final prodLogs = await _datasource.fetchDpsProductionLogs(range.startDate, range.endDate);
    final products = await _datasource.fetchProducts();
    final Map<int, double> productPrices = {
      for (final p in products)
        (p['id'] as num).toInt(): ((p['price'] as num?)?.toDouble() ?? 0.0),
    };

    double totalProduction = 0.0;
    for (final log in prodLogs) {
      final pid = (log['product_id'] as num?)?.toInt();
      final qty = ((log['quantity'] as num?)?.toDouble() ?? 0.0);
      if (pid != null && productPrices.containsKey(pid)) {
        totalProduction += qty * productPrices[pid]!;
      }
    }

    return FinancialReportModel(
      monthlySale: totalSale,
      monthlyRecovery: totalRecovery,
      monthlyProduction: totalProduction,
    );
  }

  @override
  Future<ProductionReportModel> getProductionReport(ReportDateRange range) async {
    final prodLogs = await _datasource.fetchDpsProductionLogs(range.startDate, range.endDate);
    final products = await _datasource.fetchProducts();

    // Group logs by product_id
    final Map<int, double> quantities = {};
    final Map<int, double> unitWeights = {};

    for (final log in prodLogs) {
      final pid = (log['product_id'] as num?)?.toInt();
      if (pid == null) continue;
      final qty = ((log['quantity'] as num?)?.toDouble() ?? 0.0);
      final uWeight = ((log['unit_weight'] as num?)?.toDouble() ?? 0.0);

      quantities[pid] = (quantities[pid] ?? 0.0) + qty;
      if (uWeight > 0) {
        unitWeights[pid] = uWeight;
      }
    }

    final List<ProductionReportItem> items = [];
    double grandQty = 0.0;
    double grandWeight = 0.0;
    double grandValue = 0.0;

    for (final p in products) {
      final pid = (p['id'] as num).toInt();
      final name = (p['name'] as String?) ?? 'Product #$pid';
      final basePrice = ((p['price'] as num?)?.toDouble() ?? 0.0);
      final defaultWeight = ((p['weight'] as num?)?.toDouble() ?? 0.0);
      final qty = quantities[pid] ?? 0.0;

      // Only include products that had production in this period
      if (qty <= 0) continue;

      final uWeight = (unitWeights[pid] != null && unitWeights[pid]! > 0)
          ? unitWeights[pid]!
          : defaultWeight;
      final totalWeight = qty * uWeight;
      final prodValue = qty * basePrice;

      items.add(ProductionReportItem(
        productId: pid,
        productName: name,
        quantity: qty,
        unitWeight: uWeight,
        totalWeight: totalWeight,
        basePrice: basePrice,
        productionValue: prodValue,
      ));

      grandQty += qty;
      grandWeight += totalWeight;
      grandValue += prodValue;
    }

    // Sort items by quantity descending
    items.sort((a, b) => b.quantity.compareTo(a.quantity));

    return ProductionReportModel(
      items: items,
      totalQuantity: grandQty,
      totalWeight: grandWeight,
      totalProductionValue: grandValue,
    );
  }

  @override
  Future<SaleStockReportModel> getSaleStockReport(ReportDateRange range) async {
    final products = await _datasource.fetchProducts();
    final allTx = await _datasource.fetchInventoryTransactionsUpTo(range.endDate);
    final prodLogs = await _datasource.fetchDpsProductionLogs(range.startDate, range.endDate);
    final soldItems = await _datasource.fetchSoldInvoiceItems(range.startDate, range.endDate);

    // Opening balances per product: tx before range.startDate
    final Map<int, double> openingMap = {};
    for (final tx in allTx) {
      if (tx['item_type'] != 'PRODUCT') continue;
      final pid = (tx['item_id'] as num?)?.toInt();
      if (pid == null) continue;

      final txDateStr = tx['transaction_date'] as String?;
      if (txDateStr == null) continue;
      final txDate = DateTime.tryParse(txDateStr);
      if (txDate == null || !txDate.isBefore(range.startDate)) continue;

      final qty = ((tx['quantity'] as num?)?.toDouble() ?? 0.0);
      final type = tx['transaction_type'] as String?;
      if (type == 'IN') {
        openingMap[pid] = (openingMap[pid] ?? 0.0) + qty;
      } else if (type == 'OUT') {
        openingMap[pid] = (openingMap[pid] ?? 0.0) - qty;
      }
    }

    // Produced in period (b): sum from DPS logs (fallback to inventory IN within period)
    final Map<int, double> producedMap = {};
    for (final log in prodLogs) {
      final pid = (log['product_id'] as num?)?.toInt();
      if (pid == null) continue;
      final qty = ((log['quantity'] as num?)?.toDouble() ?? 0.0);
      producedMap[pid] = (producedMap[pid] ?? 0.0) + qty;
    }

    // Sold in period (c): sum from invoice_items
    final Map<int, double> soldMap = {};
    for (final item in soldItems) {
      final pid = (item['product_id'] as num?)?.toInt();
      if (pid == null) continue;
      final qty = ((item['quantity'] as num?)?.toDouble() ?? 0.0);
      soldMap[pid] = (soldMap[pid] ?? 0.0) + qty;
    }

    final List<SaleStockReportItem> items = [];
    double totalOpening = 0.0;
    double totalProduced = 0.0;
    double totalSold = 0.0;
    double totalStock = 0.0;
    double totalStockValue = 0.0;

    for (final p in products) {
      final pid = (p['id'] as num).toInt();
      final name = (p['name'] as String?) ?? 'Product #$pid';
      final price = ((p['price'] as num?)?.toDouble() ?? 0.0);

      final a = openingMap[pid] ?? 0.0;
      final b = producedMap[pid] ?? 0.0;
      final c = soldMap[pid] ?? 0.0;
      final stock = a + b - c;

      // Only skip items with zero stock and zero transaction flow
      if (a == 0 && b == 0 && c == 0) continue;

      items.add(SaleStockReportItem(
        productId: pid,
        productName: name,
        openingBalance: a,
        produced: b,
        sold: c,
        stock: stock,
        unitPrice: price,
      ));

      totalOpening += a;
      totalProduced += b;
      totalSold += c;
      totalStock += stock;
      totalStockValue += (stock * price);
    }

    return SaleStockReportModel(
      items: items,
      totalOpening: totalOpening,
      totalProduced: totalProduced,
      totalSold: totalSold,
      totalStock: totalStock,
      totalStockValue: totalStockValue,
    );
  }

  @override
  Future<ProductionExpenditureModel> getProductionExpenditure(
    ReportDateRange range, {
    double? totalWeight,
  }) async {
    // 1. Calculate or use total weight
    double weight = totalWeight ?? 0.0;
    if (weight <= 0) {
      final prodReport = await getProductionReport(range);
      weight = prodReport.totalWeight;
    }

    // 2. Fetch expenses and procurements
    final expenses = await _datasource.fetchExpenses(range.startDate, range.endDate);
    final procurements = await _datasource.fetchProcurements(range.startDate, range.endDate);

    double totalProcurements = 0.0;
    for (final proc in procurements) {
      totalProcurements += ((proc['grand_total'] as num?)?.toDouble() ?? 0.0);
    }

    // Map amounts by expense_head_id
    final Map<int, double> headAmounts = {};
    final Map<int, String> headNames = {};

    for (final exp in expenses) {
      final hid = (exp['expense_head_id'] as num?)?.toInt();
      if (hid == null) continue;
      final amt = ((exp['amount'] as num?)?.toDouble() ?? 0.0);
      headAmounts[hid] = (headAmounts[hid] ?? 0.0) + amt;

      if (!headNames.containsKey(hid)) {
        final headMap = exp['expense_heads'];
        if (headMap is Map && headMap['name'] != null) {
          headNames[hid] = headMap['name'].toString();
        }
      }
    }

    // Category builders
    ExpenditureCategoryDetail buildCategory(
      String name,
      List<int> headIds, {
      double extraAmount = 0.0,
      String? extraLabel,
    }) {
      double total = extraAmount;
      final List<ExpenseItemDetail> subHeads = [];

      if (extraAmount > 0 && extraLabel != null) {
        subHeads.add(ExpenseItemDetail(
          expenseHeadId: 0,
          expenseHeadName: extraLabel,
          amount: extraAmount,
        ));
      }

      for (final hid in headIds) {
        final amt = headAmounts[hid] ?? 0.0;
        final hName = headNames[hid] ?? 'Head #$hid';
        subHeads.add(ExpenseItemDetail(
          expenseHeadId: hid,
          expenseHeadName: hName,
          amount: amt,
        ));
        total += amt;
      }

      final costPerKg = weight > 0 ? (total / weight) : 0.0;
      return ExpenditureCategoryDetail(
        categoryName: name,
        totalAmount: total,
        costPerKg: costPerKg,
        subHeads: subHeads,
      );
    }

    // 1. Pure Production Expenditure:
    // Raw Material / procurement: Head 31 + procurements
    // Other production material: Head 14
    // Fuel & Gas: Head 12
    // Factory Bills & Rent: Head 8
    // Generator Diesel: Head 13
    // Salary: Head 9
    // Labour Dining: Head 11
    // Labour Overtime: Head 10
    final pureProduction = buildCategory(
      'Pure production expenditure',
      [31, 14, 12, 8, 13, 9, 11, 10],
      extraAmount: totalProcurements,
      extraLabel: 'Procurements (Raw Material)',
    );

    // 2. Management Overhead
    final managementOverhead = buildCategory(
      'Management Over Head',
      [], // staff salary if dedicated
    );

    // 3. Maintenance Overhead:
    // Machinary & Maintenance (17), Tools & Machinery (27), Labour Medicine (30)
    final maintenanceOverhead = buildCategory(
      'Maintenance over head',
      [17, 27, 30],
    );

    // 4. Sale Overhead:
    // Delivery Rent (20), Testing & PR (26)
    final saleOverhead = buildCategory(
      'Sale Over head',
      [20, 26],
    );

    // 5. Factory Overhead:
    // Factory Entertainment (21), Misc Expenditure (15)
    final factoryOverhead = buildCategory(
      'Factory Over Head',
      [21, 15],
    );

    // Total Expenditure for production
    final totalExpenditure = pureProduction.totalAmount +
        managementOverhead.totalAmount +
        maintenanceOverhead.totalAmount +
        saleOverhead.totalAmount +
        factoryOverhead.totalAmount;
    final totalCostPerKg = weight > 0 ? (totalExpenditure / weight) : 0.0;

    final pureCostPerKg = pureProduction.costPerKg;
    final overheadsCostPerKg = managementOverhead.costPerKg +
        maintenanceOverhead.costPerKg +
        saleOverhead.costPerKg +
        factoryOverhead.costPerKg;
    final grandTotalCostPerKg = pureCostPerKg + overheadsCostPerKg;

    // Non-production categories from Image 2
    final vehicles = buildCategory('Vehicles', [7]);
    final domestic = buildCategory('Domestic', [1, 2, 3, 4, 5, 6]);
    final development = buildCategory('Development', [18, 29, 16, 19]);

    return ProductionExpenditureModel(
      totalWeight: weight,
      pureProduction: pureProduction,
      managementOverhead: managementOverhead,
      maintenanceOverhead: maintenanceOverhead,
      saleOverhead: saleOverhead,
      factoryOverhead: factoryOverhead,
      totalExpenditure: totalExpenditure,
      totalCostPerKg: totalCostPerKg,
      pureProductionCostPerKg: pureCostPerKg,
      overheadsCostPerKg: overheadsCostPerKg,
      grandTotalCostPerKg: grandTotalCostPerKg,
      vehicles: vehicles,
      domestic: domestic,
      development: development,
    );
  }

  @override
  Future<MonthlyClosingModel> getMonthlyClosingReport(
    ReportDateRange range, {
    ProductionExpenditureModel? expenditureModel,
  }) async {
    final expModel = expenditureModel ?? await getProductionExpenditure(range);

    // 1. Raw Stock & Finished Goods Stock Valuation
    final products = await _datasource.fetchProducts();
    final rawMaterials = await _datasource.fetchRawMaterials();
    final allTx = await _datasource.fetchInventoryTransactionsUpTo(range.endDate);

    final Map<int, double> productPrices = {
      for (final p in products)
        (p['id'] as num).toInt(): ((p['price'] as num?)?.toDouble() ?? 0.0),
    };
    final Map<int, double> rawPrices = {
      for (final r in rawMaterials)
        (r['id'] as num).toInt(): ((r['price'] as num?)?.toDouble() ?? 0.0),
    };

    double rawOpening = 0.0;
    double rawClosing = 0.0;
    double prodOpening = 0.0;
    double prodClosing = 0.0;

    final Map<int, double> rawStockOpeningMap = {};
    final Map<int, double> rawStockClosingMap = {};
    final Map<int, double> prodStockOpeningMap = {};
    final Map<int, double> prodStockClosingMap = {};

    for (final tx in allTx) {
      final itemType = tx['item_type'] as String?;
      final itemId = (tx['item_id'] as num?)?.toInt();
      if (itemId == null) continue;

      final txDateStr = tx['transaction_date'] as String?;
      if (txDateStr == null) continue;
      final txDate = DateTime.tryParse(txDateStr);
      if (txDate == null) continue;

      final qty = ((tx['quantity'] as num?)?.toDouble() ?? 0.0);
      final delta = (tx['transaction_type'] == 'IN') ? qty : -qty;

      final isOpening = txDate.isBefore(range.startDate);
      final isClosing = !txDate.isAfter(range.endDate);

      if (itemType == 'RAW_MATERIAL') {
        if (isOpening) rawStockOpeningMap[itemId] = (rawStockOpeningMap[itemId] ?? 0.0) + delta;
        if (isClosing) rawStockClosingMap[itemId] = (rawStockClosingMap[itemId] ?? 0.0) + delta;
      } else if (itemType == 'PRODUCT') {
        if (isOpening) prodStockOpeningMap[itemId] = (prodStockOpeningMap[itemId] ?? 0.0) + delta;
        if (isClosing) prodStockClosingMap[itemId] = (prodStockClosingMap[itemId] ?? 0.0) + delta;
      }
    }

    rawStockOpeningMap.forEach((id, qty) {
      if (qty > 0 && rawPrices.containsKey(id)) rawOpening += qty * rawPrices[id]!;
    });
    rawStockClosingMap.forEach((id, qty) {
      if (qty > 0 && rawPrices.containsKey(id)) rawClosing += qty * rawPrices[id]!;
    });

    prodStockOpeningMap.forEach((id, qty) {
      if (qty > 0 && productPrices.containsKey(id)) prodOpening += qty * productPrices[id]!;
    });
    prodStockClosingMap.forEach((id, qty) {
      if (qty > 0 && productPrices.containsKey(id)) prodClosing += qty * productPrices[id]!;
    });

    // 2. Recoverable (Client Balances from Ledger) & Payables (Vendor Balances)
    final ledgerEntries = await _datasource.fetchLedgerEntriesUpTo(range.endDate);

    final Map<int, double> clientOpening = {};
    final Map<int, double> clientClosing = {};
    final Map<int, double> vendorOpening = {};
    final Map<int, double> vendorClosing = {};

    for (final entry in ledgerEntries) {
      final partyType = entry['party_type'] as String?;
      final partyId = (entry['party_id'] as num?)?.toInt();
      if (partyId == null) continue;

      final entryDateStr = entry['entry_date'] as String?;
      if (entryDateStr == null) continue;
      final entryDate = DateTime.tryParse(entryDateStr);
      if (entryDate == null) continue;

      final amt = ((entry['amount'] as num?)?.toDouble() ?? 0.0);
      final isDebit = entry['entry_type'] == 'debit';

      final isOpening = entryDate.isBefore(range.startDate);
      final isClosing = !entryDate.isAfter(range.endDate);

      if (partyType == 'client') {
        // Client: Debit increases balance (receivable), credit decreases
        final delta = isDebit ? amt : -amt;
        if (isOpening) clientOpening[partyId] = (clientOpening[partyId] ?? 0.0) + delta;
        if (isClosing) clientClosing[partyId] = (clientClosing[partyId] ?? 0.0) + delta;
      } else if (partyType == 'vendor') {
        // Vendor: Credit increases balance (payable), debit decreases
        final delta = isDebit ? -amt : amt;
        if (isOpening) vendorOpening[partyId] = (vendorOpening[partyId] ?? 0.0) + delta;
        if (isClosing) vendorClosing[partyId] = (vendorClosing[partyId] ?? 0.0) + delta;
      }
    }

    double recoverableOpening = 0.0;
    double recoverableClosing = 0.0;
    clientOpening.values.where((b) => b > 0).forEach((b) => recoverableOpening += b);
    clientClosing.values.where((b) => b > 0).forEach((b) => recoverableClosing += b);

    double payablesOpening = 0.0;
    double payablesClosing = 0.0;
    vendorOpening.values.where((b) => b > 0).forEach((b) => payablesOpening += b);
    vendorClosing.values.where((b) => b > 0).forEach((b) => payablesClosing += b);

    // 3. Cash in Hand
    final cashInHandOpening = await _datasource.fetchCashInHandAsOf(range.startDate);
    final cashInHandClosing = await _datasource.fetchCashInHandAsOf(range.endDate);

    // 4. Balance = Raw Stock (+) + Finish Product (+) + Recoverable (+) + Cash (+) - Payables (-)
    final balanceOpening = rawOpening + prodOpening + recoverableOpening + cashInHandOpening - payablesOpening;
    final balanceClosing = rawClosing + prodClosing + recoverableClosing + cashInHandClosing - payablesClosing;

    // 5. Domestic & Production Expenditure
    final domesticExp = expModel.domestic.totalAmount;
    final prodExp = expModel.totalExpenditure;

    // 6. Total
    final totalOpening = balanceOpening;
    final totalClosing = balanceClosing - domesticExp - prodExp;
    final valueAddition = totalClosing - totalOpening;

    return MonthlyClosingModel(
      rawStockOpening: rawOpening,
      rawStockClosing: rawClosing,
      finishProductOpening: prodOpening,
      finishProductClosing: prodClosing,
      recoverableOpening: recoverableOpening,
      recoverableClosing: recoverableClosing,
      cashInHandOpening: cashInHandOpening,
      cashInHandClosing: cashInHandClosing,
      payablesOpening: payablesOpening,
      payablesClosing: payablesClosing,
      balanceOpening: balanceOpening,
      balanceClosing: balanceClosing,
      domesticExpenditure: domesticExp,
      productionExpenditure: prodExp,
      totalOpening: totalOpening,
      totalClosing: totalClosing,
      valueAddition: valueAddition,
    );
  }
}
