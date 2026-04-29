// features/expense/presentation/views/sidebar.dart
import 'package:flutter/material.dart';
import 'package:ledgerly/features/orders/presentation/pages/order_dashboard.dart';
import 'package:ledgerly/features/procurement/presentation/pages/procurement_dashboard.dart';
import 'package:ledgerly/features/products/presentation/pages/product_dashboard.dart';
import 'package:ledgerly/features/raw_material/presentation/pages/raw_material_dashboard.dart';
import 'package:ledgerly/features/receipts/presentation/pages/receipts_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/client/presentation/pages/client_dashboard_view.dart';
import 'features/expense/presentation/pages/expense_dashboard_view.dart';
import 'features/ledger/presentation/pages/ledger_page.dart';
import 'features/vender/presentation/pages/vendor_dashboard_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; // Default to Expenses as per your request

  // Placeholder for future modules
  final List<Widget> _pages = [
    const LedgerPage(),
    const OrderDashboard(),
    const ReceiptsDashboard(),
    const ClientDashboardView(),
    const VenderDashboardView(),
    const ProductDashboard(),
    const RawMaterialDashboard(),
    const ProcurementDashboard(),
    const ExpenseDashboardView(),
    // const Center(child: Text('Settings Module')),
  ];

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    // The AuthWrapper will automatically redirect you back to the Login Screen!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // The Sidebar
          NavigationRail(
            extended: true, // Set to false if you want it collapsed
            backgroundColor: Colors.white,
            selectedIndex: _selectedIndex,
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
                      Text('UC', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'Inventory Management',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.book_outlined),
                selectedIcon: Icon(Icons.book),
                label: Text('Ledger'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: Text('Orders'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.payments_outlined),
                selectedIcon: Icon(Icons.payments),
                label: Text('Payments'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Clients'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('Venders'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: Text('Raw Materials'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: Text('Procurement'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet),
                label: Text('Expenses'),
              ),

              // NavigationRailDestination(
              //   icon: Icon(Icons.settings_outlined),
              //   selectedIcon: Icon(Icons.settings),
              //   label: Text('Settings'),
              // ),
            ],
            // Signout button at the bottom of the rail
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
          ),

          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: Color(0xFFEEEEEE),
          ),

          // Main Content Area
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
