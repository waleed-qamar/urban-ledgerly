import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/overview_remote_datasource.dart';

part 'overview_providers.g.dart';

@riverpod
OverviewRemoteDatasource overviewRemoteDatasource(Ref ref) {
  return OverviewRemoteDatasource(ref.watch(supabaseClientProvider));
}

// Data models for analytics
class ExpenditureOverviewData {
  final double totalExpenditure;
  final double expenditureThisMonth;
  final double expenditureToday;
  final double averageDaily;
  final double averageMonthly;
  final Map<String, double> expensesByCategory;
  final Map<String, double> monthlyTrend;
  final List<Map<String, dynamic>> recentTransactions;

  ExpenditureOverviewData({
    required this.totalExpenditure,
    required this.expenditureThisMonth,
    required this.expenditureToday,
    required this.averageDaily,
    required this.averageMonthly,
    required this.expensesByCategory,
    required this.monthlyTrend,
    required this.recentTransactions,
  });
}

class RecoveryOverviewData {
  final double totalRecovery;
  final double recoveryThisMonth;
  final double recoveryRate;
  final double outstandingBalance;
  final double overdueAmount;
  final Map<String, double> recoveryByCustomer;
  final Map<String, double> recoveryByPaymentMethod;
  final Map<String, double> monthlyTrend;
  final Map<String, double> agingAnalysis; // '0-30', '31-60', '61-90', '90+'

  RecoveryOverviewData({
    required this.totalRecovery,
    required this.recoveryThisMonth,
    required this.recoveryRate,
    required this.outstandingBalance,
    required this.overdueAmount,
    required this.recoveryByCustomer,
    required this.recoveryByPaymentMethod,
    required this.monthlyTrend,
    required this.agingAnalysis,
  });
}

class SalesOverviewData {
  final double totalSales;
  final double salesToday;
  final double salesThisMonth;
  final double salesGrowth;
  final int orderCount;
  final double averageOrderValue;
  final double grossRevenue;
  final double netRevenue;
  final Map<String, double> salesByProduct;
  final Map<String, double> salesByCategory;
  final Map<String, double> salesByCustomer;
  final Map<String, double> salesTrend;
  final List<Map<String, dynamic>> topProducts; // name, amount, quantity
  final Map<String, double> salesFunnel; // 'Orders', 'Invoiced', 'Recovered'

  SalesOverviewData({
    required this.totalSales,
    required this.salesToday,
    required this.salesThisMonth,
    required this.salesGrowth,
    required this.orderCount,
    required this.averageOrderValue,
    required this.grossRevenue,
    required this.netRevenue,
    required this.salesByProduct,
    required this.salesByCategory,
    required this.salesByCustomer,
    required this.salesTrend,
    required this.topProducts,
    required this.salesFunnel,
  });
}

@riverpod
Future<ExpenditureOverviewData> expenditureOverview(Ref ref) async {
  final datasource = ref.watch(overviewRemoteDatasourceProvider);
  final expenses = await datasource.fetchExpenses();
  final disbursements = await datasource.fetchDisbursements();

  final now = DateTime.now();
  double total = 0.0;
  double thisMonth = 0.0;
  double today = 0.0;

  DateTime? earliestDate;

  final Map<String, double> byCategory = {};
  final Map<String, double> trend = {};
  final List<Map<String, dynamic>> recent = [];

  // Helper to parse date safely
  DateTime parseDate(dynamic d) {
    if (d is String) return DateTime.parse(d);
    if (d is DateTime) return d;
    return DateTime.now();
  }

  // Process expenses
  for (final exp in expenses) {
    final amt = (exp['amount'] as num?)?.toDouble() ?? 0.0;
    final dt = parseDate(exp['date']);
    
    total += amt;
    if (earliestDate == null || dt.isBefore(earliestDate)) {
      earliestDate = dt;
    }

    if (dt.year == now.year && dt.month == now.month) {
      thisMonth += amt;
    }
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      today += amt;
    }

    // Category
    final head = exp['expense_heads'] as Map<String, dynamic>?;
    final categoryName = head?['name'] ?? 'Uncategorized';
    byCategory[categoryName] = (byCategory[categoryName] ?? 0.0) + amt;

    // Trend
    final monthKey = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
    trend[monthKey] = (trend[monthKey] ?? 0.0) + amt;

    recent.add({
      'type': 'expense',
      'title': categoryName,
      'remarks': exp['remarks'] ?? '',
      'amount': amt,
      'date': dt,
    });
  }

  // Process disbursements
  for (final disb in disbursements) {
    final amt = (disb['total_amount'] as num?)?.toDouble() ?? 0.0;
    final dt = parseDate(disb['paid_date']);

    total += amt;
    if (earliestDate == null || dt.isBefore(earliestDate)) {
      earliestDate = dt;
    }

    if (dt.year == now.year && dt.month == now.month) {
      thisMonth += amt;
    }
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      today += amt;
    }

    final categoryName = disb['category'] ?? 'Vendor Payments';
    byCategory[categoryName] = (byCategory[categoryName] ?? 0.0) + amt;

    final monthKey = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
    trend[monthKey] = (trend[monthKey] ?? 0.0) + amt;

    recent.add({
      'type': 'disbursement',
      'title': categoryName,
      'remarks': disb['remarks'] ?? '',
      'amount': amt,
      'date': dt,
    });
  }

  recent.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

  // Compute Averages
  double avgDaily = 0.0;
  double avgMonthly = 0.0;
  if (earliestDate != null) {
    final totalDays = now.difference(earliestDate).inDays;
    avgDaily = totalDays > 0 ? total / totalDays : total;

    final totalMonths = (now.year - earliestDate.year) * 12 + now.month - earliestDate.month + 1;
    avgMonthly = totalMonths > 0 ? total / totalMonths : total;
  }

  return ExpenditureOverviewData(
    totalExpenditure: total,
    expenditureThisMonth: thisMonth,
    expenditureToday: today,
    averageDaily: avgDaily,
    averageMonthly: avgMonthly,
    expensesByCategory: byCategory,
    monthlyTrend: trend,
    recentTransactions: recent.take(10).toList(),
  );
}

@riverpod
Future<RecoveryOverviewData> recoveryOverview(Ref ref) async {
  final datasource = ref.watch(overviewRemoteDatasourceProvider);
  final receipts = await datasource.fetchReceipts();
  final invoices = await datasource.fetchInvoices();
  final allocations = await datasource.fetchReceiptAllocations();
  final clientsList = await datasource.fetchClients();

  final Map<int, Map<String, dynamic>> clientsMap = {
    for (final c in clientsList)
      (c['id'] as num).toInt(): c
  };

  final now = DateTime.now();
  double totalRec = 0.0;
  double recThisMonth = 0.0;

  final Map<String, double> byCustomer = {};
  final Map<String, double> byMethod = {};
  final Map<String, double> trend = {};

  DateTime parseDate(dynamic d) {
    if (d is String) return DateTime.parse(d);
    if (d is DateTime) return d;
    return DateTime.now();
  }

  // Process receipts
  for (final rec in receipts) {
    final amt = (rec['total_amount'] as num?)?.toDouble() ?? 0.0;
    final dt = parseDate(rec['received_date']);

    totalRec += amt;
    if (dt.year == now.year && dt.month == now.month) {
      recThisMonth += amt;
    }

    final clientId = (rec['client_id'] ?? rec['clientId'] as num?)?.toInt();
    final client = clientId != null ? clientsMap[clientId] : null;
    final clientName = client?['clientName'] ?? 'Unknown Client';
    byCustomer[clientName] = (byCustomer[clientName] ?? 0.0) + amt;

    final method = rec['payment_method'] ?? 'cash';
    byMethod[method] = (byMethod[method] ?? 0.0) + amt;

    final monthKey = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
    trend[monthKey] = (trend[monthKey] ?? 0.0) + amt;
  }

  // Process invoices for outstanding & overdue
  double totalInvoiced = 0.0;
  double outstanding = 0.0;
  double overdue = 0.0;

  final Map<String, double> aging = {
    '0-30': 0.0,
    '31-60': 0.0,
    '61-90': 0.0,
    '90+': 0.0,
  };

  // Map allocations by invoice_id
  final Map<int, double> invoiceAllocations = {};
  for (final alloc in allocations) {
    final invId = (alloc['invoice_id'] as num?)?.toInt() ?? 0;
    final amt = (alloc['amount'] as num?)?.toDouble() ?? 0.0;
    invoiceAllocations[invId] = (invoiceAllocations[invId] ?? 0.0) + amt;
  }

  for (final inv in invoices) {
    final invId = (inv['id'] as num?)?.toInt() ?? 0;
    final grandTotal = (inv['grand_total'] as num?)?.toDouble() ?? 0.0;
    final dt = parseDate(inv['issue_date']);

    totalInvoiced += grandTotal;

    final paid = invoiceAllocations[invId] ?? 0.0;
    final remaining = grandTotal - paid;

    if (remaining > 0) {
      outstanding += remaining;
      final ageInDays = now.difference(dt).inDays;

      if (ageInDays > 30) {
        overdue += remaining;
      }

      if (ageInDays <= 30) {
        aging['0-30'] = (aging['0-30'] ?? 0.0) + remaining;
      } else if (ageInDays <= 60) {
        aging['31-60'] = (aging['31-60'] ?? 0.0) + remaining;
      } else if (ageInDays <= 90) {
        aging['61-90'] = (aging['61-90'] ?? 0.0) + remaining;
      } else {
        aging['90+'] = (aging['90+'] ?? 0.0) + remaining;
      }
    }
  }

  final rate = totalInvoiced > 0 ? (totalRec / totalInvoiced) * 100 : 0.0;

  return RecoveryOverviewData(
    totalRecovery: totalRec,
    recoveryThisMonth: recThisMonth,
    recoveryRate: rate,
    outstandingBalance: outstanding,
    overdueAmount: overdue,
    recoveryByCustomer: byCustomer,
    recoveryByPaymentMethod: byMethod,
    monthlyTrend: trend,
    agingAnalysis: aging,
  );
}

@riverpod
Future<SalesOverviewData> salesOverview(Ref ref) async {
  final datasource = ref.watch(overviewRemoteDatasourceProvider);
  final invoices = await datasource.fetchInvoices();
  final orders = await datasource.fetchOrders();
  final receipts = await datasource.fetchReceipts();
  final clientsList = await datasource.fetchClients();

  final Map<int, Map<String, dynamic>> clientsMap = {
    for (final c in clientsList)
      (c['id'] as num).toInt(): c
  };

  final now = DateTime.now();
  double totalSales = 0.0;
  double salesToday = 0.0;
  double salesThisMonth = 0.0;
  double salesLastMonth = 0.0;
  double grossRevenue = 0.0;
  double netRevenue = 0.0;

  final Map<String, double> byProduct = {};
  final Map<String, double> byCategory = {}; // Client Department
  final Map<String, double> byCustomer = {};
  final Map<String, double> trend = {};
  final Map<String, Map<String, dynamic>> productStats = {}; // name -> {amount, quantity}

  DateTime parseDate(dynamic d) {
    if (d is String) return DateTime.parse(d);
    if (d is DateTime) return d;
    return DateTime.now();
  }

  final lastMonth = now.month == 1 ? 12 : now.month - 1;
  final lastMonthYear = now.month == 1 ? now.year - 1 : now.year;

  for (final inv in invoices) {
    final grandTotal = (inv['grand_total'] as num?)?.toDouble() ?? 0.0;
    final subTotal = (inv['sub_total'] as num?)?.toDouble() ?? 0.0;
    final dt = parseDate(inv['issue_date']);

    totalSales += grandTotal;
    grossRevenue += grandTotal;
    netRevenue += subTotal;

    if (dt.year == now.year && dt.month == now.month) {
      salesThisMonth += grandTotal;
    }
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      salesToday += grandTotal;
    }
    if (dt.year == lastMonthYear && dt.month == lastMonth) {
      salesLastMonth += grandTotal;
    }

    final clientId = (inv['client_id'] ?? inv['clientId'] as num?)?.toInt();
    final client = clientId != null ? clientsMap[clientId] : null;
    final clientName = client?['clientName'] ?? 'Unknown Client';
    byCustomer[clientName] = (byCustomer[clientName] ?? 0.0) + grandTotal;

    final dept = client?['department'] ?? 'General';
    byCategory[dept] = (byCategory[dept] ?? 0.0) + grandTotal;

    final monthKey = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
    trend[monthKey] = (trend[monthKey] ?? 0.0) + grandTotal;

    // Process invoice items
    final items = inv['invoice_items'] as List<dynamic>? ?? [];
    for (final item in items) {
      final qty = (item['quantity'] as num?)?.toDouble() ?? 0.0;
      final price = (item['total_price'] as num?)?.toDouble() ?? 0.0;
      final product = item['products'] as Map<String, dynamic>?;
      final productName = product?['name'] ?? 'Unknown Product';

      byProduct[productName] = (byProduct[productName] ?? 0.0) + price;

      if (!productStats.containsKey(productName)) {
        productStats[productName] = {'name': productName, 'amount': 0.0, 'quantity': 0.0};
      }
      productStats[productName]!['amount'] = (productStats[productName]!['amount'] as double) + price;
      productStats[productName]!['quantity'] = (productStats[productName]!['quantity'] as double) + qty;
    }
  }

  // Growth
  double growth = 0.0;
  if (salesLastMonth > 0) {
    growth = ((salesThisMonth - salesLastMonth) / salesLastMonth) * 100;
  }

  // AOV
  final int invoiceCount = invoices.length;
  final double aov = invoiceCount > 0 ? totalSales / invoiceCount : 0.0;

  // Top Products
  final topProductsList = productStats.values.toList();
  topProductsList.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

  // Funnel
  double ordersVal = 0.0;
  for (final ord in orders) {
    final items = ord['order_items'] as List<dynamic>? ?? [];
    for (final item in items) {
      final qty = (item['quantity'] as num?)?.toDouble() ?? 0.0;
      final prc = (item['price'] as num?)?.toDouble() ?? 0.0;
      ordersVal += qty * prc;
    }
  }

  double recoveredVal = 0.0;
  for (final rec in receipts) {
    recoveredVal += (rec['total_amount'] as num?)?.toDouble() ?? 0.0;
  }

  final funnel = {
    'Orders': ordersVal,
    'Invoiced': totalSales,
    'Recovered': recoveredVal,
  };

  return SalesOverviewData(
    totalSales: totalSales,
    salesToday: salesToday,
    salesThisMonth: salesThisMonth,
    salesGrowth: growth,
    orderCount: orders.length,
    averageOrderValue: aov,
    grossRevenue: grossRevenue,
    netRevenue: netRevenue,
    salesByProduct: byProduct,
    salesByCategory: byCategory,
    salesByCustomer: byCustomer,
    salesTrend: trend,
    topProducts: topProductsList.take(5).toList(),
    salesFunnel: funnel,
  );
}
