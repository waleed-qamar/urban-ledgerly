// features/expense/presentation/views/sidebar.dart
import 'package:flutter/material.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import 'package:ledgerly/dashboard.dart';
import 'package:ledgerly/features/audit_logs/presentation/pages/audit_log_page.dart';
import 'package:ledgerly/features/employee/presentation/pages/operator_dashboard.dart';
import 'package:ledgerly/features/employee/presentation/pages/users_dashboard.dart';
import 'package:ledgerly/features/payroll/presentation/pages/payroll_dashboard.dart';
import 'package:ledgerly/features/orders/presentation/pages/order_dashboard.dart';
import 'package:ledgerly/features/procurement/presentation/pages/procurement_dashboard.dart';
import 'package:ledgerly/features/products/presentation/pages/product_dashboard.dart';
import 'package:ledgerly/features/raw_material/presentation/pages/raw_material_dashboard.dart';
import 'package:ledgerly/features/receipts/presentation/pages/receipts_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/account_ledger/presentation/pages/account_dashboard.dart';
import 'features/client/presentation/pages/client_dashboard_view.dart';
import 'features/expense/presentation/pages/expense_dashboard_view.dart';
import 'features/ledger/presentation/pages/ledger_page.dart';
import 'package:ledgerly/features/vender/presentation/pages/vendor_dashboard_view.dart';
import 'package:ledgerly/features/dps/presentation/pages/dps_dashboard.dart';
import 'package:ledgerly/features/overview/overview_dashboard.dart';
import 'package:ledgerly/features/reports/presentation/pages/reports_dashboard_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/features/auth/presentation/provider/current_employee_provider.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(userPermissionsProvider);
      ref.invalidate(currentEmployeeProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showOverview = ref.watch(hasPermissionProvider('overview.read'));
    final showAccounts = ref.watch(hasPermissionProvider('accounts.read'));
    final showLedger = ref.watch(hasPermissionProvider('ledger.read'));
    final showOrders = ref.watch(hasPermissionProvider('orders.read'));
    final showReceipts = ref.watch(hasPermissionProvider('receipts.read'));
    final showClients = ref.watch(hasPermissionProvider('clients.read'));
    final showVendors = ref.watch(hasPermissionProvider('vendors.read'));
    final showProducts = ref.watch(hasPermissionProvider('products.read'));
    final showRawMaterial = ref.watch(
      hasPermissionProvider('raw_material.read'),
    );
    final showProcurements = ref.watch(
      hasPermissionProvider('procurements.read'),
    );
    final showExpenses = ref.watch(hasPermissionProvider('expenses.read'));
    final showDps = ref.watch(hasPermissionProvider('dps.read'));
    final showOperators = ref.watch(hasPermissionProvider('operators.read'));
    final showPayroll = ref.watch(hasPermissionProvider('payroll.read'));
    final showUsers = ref.watch(hasPermissionProvider('employees.update'));
    // Audit Logs are master-only — no DB permission row needed
    final showAudit = ref.watch(isMasterProvider);
    // Reports are Ali-only — exclusive role above master level
    final showReports = ref.watch(isAliProvider);

    final List<(NavigationRailDestination destination, Widget page)> items = [
      (
        const NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        Dashboard(),
      ),
      if (showOverview)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: Text('Overview'),
          ),
          const OverviewDashboard(),
        ),
      if (showReports)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment),
            label: Text('Reports'),
          ),
          const ReportsDashboardPage(),
        ),
      if (showAccounts)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.account_balance_outlined),
            selectedIcon: Icon(Icons.account_balance),
            label: Text('Accounts'),
          ),
          const AccountDashboard(),
        ),
      if (showLedger)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: Text('Ledger'),
          ),
          const LedgerPage(),
        ),
      if (showOrders)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: Text('Orders'),
          ),
          const OrderDashboard(),
        ),
      if (showReceipts)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: Text('Payments'),
          ),
          const ReceiptsDashboard(),
        ),
      if (showClients)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: Text('Clients'),
          ),
          const ClientDashboardView(),
        ),
      if (showVendors)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: Text('Venders'),
          ),
          const VenderDashboardView(),
        ),
      if (showProducts)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: Text('Products'),
          ),
          const ProductDashboard(),
        ),
      if (showRawMaterial)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: Text('Raw Materials'),
          ),
          const RawMaterialDashboard(),
        ),
      if (showProcurements)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: Text('Procurement'),
          ),
          const ProcurementDashboard(),
        ),
      if (showExpenses)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: Text('Non-Vender Payments'),
          ),
          const ExpenseDashboardView(),
        ),
      if (showDps)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.precision_manufacturing_outlined),
            selectedIcon: Icon(Icons.precision_manufacturing),
            label: Text('DPS'),
          ),
          const DpsDashboard(),
        ),
      if (showOperators)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.emoji_people_outlined),
            selectedIcon: Icon(Icons.emoji_people),
            label: Text('Operators'),
          ),
          const OperatorDashboard(),
        ),
      if (showPayroll)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.request_quote_outlined),
            selectedIcon: Icon(Icons.request_quote),
            label: Text('Payroll'),
          ),
          const PayrollDashboard(),
        ),
      if (showUsers)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.supervised_user_circle_outlined),
            selectedIcon: Icon(Icons.supervised_user_circle),
            label: Text('Users & RBAC'),
          ),
          const UsersDashboard(),
        ),

      if (showAudit)
        (
          const NavigationRailDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: Text('Audit Logs'),
          ),
          const AuditLogPage(),
        ),
    ];

    final destinations = items.map((e) => e.$1).toList();
    final pages = items.map((e) => e.$2).toList();
    final selectedIndex = _selectedIndex >= destinations.length
        ? 0
        : _selectedIndex;

    return Scaffold(
      body: Row(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final minHeight = destinations.length * 60.0 + 200.0;
              final rail = NavigationRail(
                extended: true,
                backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UC',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Inventory Management',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                destinations: destinations,
                trailing: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            120,
                            19,
                            19,
                          ).withValues(alpha: 0.7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Sign Out'),
                      ),
                    ),
                  ),
                ),
              );

              if (constraints.maxHeight < minHeight) {
                return SingleChildScrollView(
                  child: SizedBox(height: minHeight, child: rail),
                );
              } else {
                return rail;
              }
            },
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: Color(0xFFEEEEEE),
          ),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
