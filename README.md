
**Project Overview**

- **Name**: Ledgerly: Business Accounts Manager
- **Purpose**: Provide a compact accounting and production tracking application aimed at small-to-medium businesses. Tracks clients, vendors, products, orders, invoices, receipts, disbursements, inventory movements, and daily production summaries (DPS).

**Quick Links**

- **Database schema & core business logic**: [DB/COMPLETE_DB_INITIALIZATION.sql](DB/COMPLETE_DB_INITIALIZATION.sql)

**Features (User-facing)**

- **Clients & Vendors**: Manage customer and supplier contacts and addresses.
- **Products & Raw Materials**: Track finished products and raw material catalog with pricing and weights.
- **Orders & Order Items**: Create customer orders and attach item lines.
- **Invoices & Invoice Items**: Issue invoices linked to orders or standalone; calculate tax, shipping and grand totals.
- **Receipts (Payments)**: Record receipts, allocate amounts to invoices, and auto-create ledger entries. Uses `create_receipt()` logic in the core SQL.
- **Disbursements (Supplier Payments)**: Record payments to vendors with ledger entries via `create_disbursement()`.
- **Ledger (Double-entry style)**: Centralized `ledger` table stores debit/credit entries for clients and vendors.
- **Accounts & Bank/Cash Transactions**: Track bank/cash accounts and `account_transactions`.
- **Inventory Transactions**: Log production, consumption and damage as inventory IN/OUT entries.
- **DPS (Daily Production Summary)**: Submit DPS reports that create production/consumption records and corresponding inventory transactions via `create_dps_report()`.
- **Exports**: Invoice PDF export; DPS XLSX export; Vendor and Non-Vendor payment XLSX exports.

**Architecture & Data Model (Surface Level)**

This project is backed by a PostgreSQL database whose complete initialization and business logic are contained in [DB/COMPLETE_DB_INITIALIZATION.sql](DB/COMPLETE_DB_INITIALIZATION.sql). The SQL file defines tables, indexes, stored procedures (RPCs), triggers and Row-Level Security policies. At a surface level:

- **Entity relationships**:
	- `clients` and `vendors` are primary parties used across invoices, receipts and disbursements.
	- `orders` -> `order_items` connect customers to product quantities and pricing.
	- `invoices` reference `orders` and `clients` and contain `invoice_items` lines.
	- `receipts` allocate funds to `invoices` via `receipt_allocations` and update the `ledger`.
	- `disbursements` create supplier-side ledger entries when payments are made.
	- `inventory_transactions` record stock changes; DPS flows create IN (production) and OUT (consumption/damage) transactions.

- **Core tables (high level)**:
	- `clients`, `vendors`, `employees`, `operators`
	- `products`, `raw_material`
	- `orders`, `order_items`
	- `invoices`, `invoice_items`
	- `receipts`, `receipt_allocations`
	- `disbursements`
	- `ledger`, `accounts`, `account_transactions`
	- `inventory_transactions`
	- `dps_reports`, `dps_production_logs`, `dps_consumption_logs`, `dps_damage_logs`

**Key Workflows (How features behave)**

- **Create a Receipt (Payment from Client)**
	- High level: A receipt is inserted into `receipts`; allocations to invoices are stored in `receipt_allocations`. For each allocation the system inserts a `credit` entry in the `ledger` for the client and invoice. Any unallocated amount becomes a client advance and is recorded as a credit ledger entry.
	- Implemented by the stored function `create_receipt(...)` in the SQL file. See [DB/COMPLETE_DB_INITIALIZATION.sql](DB/COMPLETE_DB_INITIALIZATION.sql) for full validation rules (allocation totals, invoice ownership checks, account transaction optional insertion).

- **Delete a Receipt**
	- High level: Deleting a receipt inserts reversal `debit` entries in the `ledger` for any allocations and for any leftover advance, then removes the `receipts` row. Implemented by `delete_receipt(p_receipt_id)`.

- **Create a Disbursement (Payment to Vendor)**
	- High level: Validates vendor exists and vendor balance, inserts `disbursements`, and creates a `debit` ledger entry for the vendor. Implemented by `create_disbursement(...)`.

- **Create an Expense**
	- High level: Stores expense row in `expenses` and optionally posts an `account_transactions` entry when an `account_id` is provided. Implemented by `create_expense(...)`.

- **Submit DPS Report**
	- High level: `create_dps_report(payload JSON)` creates a DPS report, writes energy, production, consumption and damage logs, and creates matching `inventory_transactions` for stock IN/OUT. Use DPS XLSX export to extract submitted reports.

**Export & Reporting Features**

- **Invoice PDF export**: The app supports rendering invoice data into a PDF file suitable for printing or sending to customers. The export assembles `invoices` and `invoice_items` with calculated totals.
- **DPS XLSX export**: Daily Production Summaries can be exported to XLSX for analysis; these exports include production logs and energy/consumption breakdowns.
- **Payment XLSX exports**: Vendor payments and non-vendor payments (and combined) can be exported to XLSX for reconciliation and bank uploads.

Notes: Export implementations are UI-level features that read the relevant tables described above and format them into PDF/XLSX. The SQL file contains the data and rules; consult the app UI code for exact export layout and styling.

**Security & Policies**

- **Row-Level Security (RLS)**: RLS is enabled across tables. Special policies:
	- `employees` are managed only by users whose `get_current_user_role()` returns `master`.
	- `accounts` are scoped to the owning `user_id` (users can only manage their own accounts).
	- Generic policies allow authenticated SELECT/INSERT but restrict UPDATE/DELETE to `master` users for many tables. See [DB/COMPLETE_DB_INITIALIZATION.sql](DB/COMPLETE_DB_INITIALIZATION.sql) for policy generation logic.

**Setup & Run (Developer / Admin)**

1. Database: Apply the SQL initialization in your Supabase or PostgreSQL instance.

```sql
-- Run the full initialization in your SQL editor
-- Copy the contents of DB/COMPLETE_DB_INITIALIZATION.sql and execute
\i DB/COMPLETE_DB_INITIALIZATION.sql
```

2. Application (Flutter): Install dependencies and run the app.

```bash
flutter pub get
flutter run
```

3. Create initial data: After DB and Auth are created, add at least one `employees` row (role `master`) to administer the system, then create initial `clients`, `vendors`, `products`.

**Verification Queries**

- List public tables: run `SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;` in your DB.
- Check functions: `SELECT proname FROM pg_proc WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public') ORDER BY proname;`

**Common Tasks (User Guidance)**

- To record a customer payment: use the Receipts UI to create a receipt and allocate to invoices. The system will automatically create ledger entries and optional account transactions.
- To pay a vendor: use the Disbursements UI; the system validates the vendor balance and writes ledger entries.
- To report production: submit a DPS report with production and consumption arrays; the system creates inventory transactions to keep stock in sync.

**Files of Interest**

- **Database & logic**: [DB/COMPLETE_DB_INITIALIZATION.sql](DB/COMPLETE_DB_INITIALIZATION.sql)
- **Flutter entry point**: [lib/main.dart](lib/main.dart)
- **Sidebar / navigation**: [lib/sidebar.dart](lib/sidebar.dart)

**Troubleshooting**

- If RLS blocks operations, ensure an `employees` record exists for the calling `auth.uid()` and that `get_current_user_role()` returns the required role.
- If receipt allocations fail, confirm invoice ownership and that allocation totals do not exceed the receipt amount.

**Contributing**

- Please open issues or pull requests. For database changes, update `DB/COMPLETE_DB_INITIALIZATION.sql` and include migration notes.

**License & Contact**

- This repository does not include a license file. Contact the maintainers for contribution and licensing details.

