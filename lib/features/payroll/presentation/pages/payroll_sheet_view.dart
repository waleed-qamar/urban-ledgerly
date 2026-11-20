import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import '../providers/payroll_providers.dart';

class PayrollSheetView extends ConsumerStatefulWidget {
  final String sheetId;

  const PayrollSheetView({super.key, required this.sheetId});

  @override
  ConsumerState<PayrollSheetView> createState() => _PayrollSheetViewState();
}

class _PayrollSheetViewState extends ConsumerState<PayrollSheetView> {
  final _currencyFormat = NumberFormat('#,##0');

  String _fmt(double val) {
    if (val == 0.0) return '—';
    return _currencyFormat.format(val);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(payrollSheetDetailProvider(widget.sheetId));
    final notifier = ref.read(
      payrollSheetDetailProvider(widget.sheetId).notifier,
    );

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.textWhite,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.textWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${state.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => notifier.loadSheet(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final sheet = state.sheet;
    if (sheet == null) {
      return const Scaffold(body: Center(child: Text('Sheet not found')));
    }

    final isReadOnly = sheet.isFinalized;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.textWhite,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  sheet.title,
                  style: const TextStyle(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFE65100).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    sheet.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: sheet.isFinalized
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sheet.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: sheet.isFinalized
                          ? Colors.green[800]
                          : Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '${sheet.company} • ${DateFormat('EEEE, MMMM d, yyyy').format(sheet.cutoffDate)}',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          if (!isReadOnly)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Finalize Sheet'),
                      content: const Text(
                        'Are you sure you want to finalize this payout sheet? Once finalized, row values can no longer be edited.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Yes, Finalize'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await notifier.finalize();
                    ref.invalidate(payrollSheetsProvider);
                  }
                },
                icon: const Icon(Icons.lock_outline, size: 18),
                label: const Text('Finalize Sheet'),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ── KPI Summary Cards ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            child: Row(
              children: [
                _buildKpiCard(
                  'Grand Total Payout',
                  '₨ ${_fmt(state.grandTotal)}',
                  Icons.payments,
                  Colors.green[700]!,
                  highlight: true,
                ),
                const SizedBox(width: 14),
                _buildKpiCard(
                  'Cash Handed Over',
                  '₨ ${_fmt(sheet.amountGiven)}',
                  Icons.account_balance_wallet,
                  Colors.blue[700]!,
                  subtitle: sheet.operatorName != null
                      ? 'To: ${sheet.operatorName}'
                      : null,
                  onTap: isReadOnly
                      ? null
                      : () => _editCashGivenDialog(
                          context,
                          sheet.amountGiven,
                          sheet.operatorName,
                        ),
                ),
                const SizedBox(width: 14),
                _buildKpiCard(
                  'Remaining Cash Balance',
                  '₨ ${_fmt(state.balance)}',
                  Icons.balance,
                  state.balance >= 0 ? Colors.teal[700]! : Colors.red[700]!,
                ),
                const SizedBox(width: 14),
                _buildKpiCard(
                  'Total Demand',
                  '₨ ${_fmt(state.totalDemand)}',
                  Icons.request_quote_outlined,
                  Colors.indigo[600]!,
                ),
                const SizedBox(width: 14),
                _buildKpiCard(
                  'Total Advance Deductions',
                  '₨ ${_fmt(state.totalAdvance)}',
                  Icons.money_off,
                  Colors.orange[800]!,
                ),
              ],
            ),
          ),

          // ── Spreadsheet Grid ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFD0D7DE)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFFE8F5E9),
                      ),
                      headingRowHeight: 46,
                      dataRowMinHeight: 46,
                      dataRowMaxHeight: 52,
                      columnSpacing: 16,
                      horizontalMargin: 16,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Sr.#',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Days',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Per Day',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Salary',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Advance',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Current',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Demand',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Payable',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Overtime',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Sync',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: [
                        ...state.rows.asMap().entries.map((entry) {
                          final index = entry.key;
                          final row = entry.value;
                          final status =
                              state.rowStatuses[row.id] ?? RowSaveStatus.idle;

                          return DataRow(
                            color: WidgetStateProperty.resolveWith((states) {
                              if (index.isOdd) return const Color(0xFFFAFAFA);
                              return Colors.white;
                            }),
                            cells: [
                              // Sr.#
                              DataCell(
                                Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: AppColors.textGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              // Name
                              DataCell(
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    row.nameSnapshot,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),

                              // Days (Editable input)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey('days_${row.id}'),
                                  initialValue: row.days > 0
                                      ? row.days.toString()
                                      : '',
                                  width: 55,
                                  isReadOnly: isReadOnly,
                                  onCommitted: (val) {
                                    final d = double.tryParse(val) ?? 0.0;
                                    notifier.updateRowInputs(row.id, days: d);
                                  },
                                ),
                              ),

                              // Per Day (Editable input)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey(
                                    'per_day_${row.id}_${row.perDay}',
                                  ),
                                  initialValue: row.perDay > 0
                                      ? row.perDay.toStringAsFixed(0)
                                      : '',
                                  width: 70,
                                  isReadOnly: isReadOnly,
                                  onCommitted: (val) {
                                    final rate = double.tryParse(val) ?? 0.0;
                                    notifier.updateRowInputs(
                                      row.id,
                                      perDay: rate,
                                    );
                                  },
                                ),
                              ),

                              // Salary (Computed)
                              DataCell(
                                Text(
                                  _fmt(row.salary),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              // Advance (Editable input)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey('advance_${row.id}'),
                                  initialValue: row.advance > 0
                                      ? row.advance.toStringAsFixed(0)
                                      : '',
                                  width: 70,
                                  isReadOnly: isReadOnly,
                                  onCommitted: (val) {
                                    final adv = double.tryParse(val) ?? 0.0;
                                    notifier.updateRowInputs(
                                      row.id,
                                      advance: adv,
                                    );
                                  },
                                ),
                              ),

                              // Current (Computed)
                              DataCell(
                                Text(
                                  _fmt(row.currentAmt),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              // Demand (Editable input)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey('demand_${row.id}'),
                                  initialValue: row.demand > 0
                                      ? row.demand.toStringAsFixed(0)
                                      : '',
                                  width: 75,
                                  backgroundColor: const Color(0xFFE3F2FD),
                                  isReadOnly: isReadOnly,
                                  onCommitted: (val) {
                                    final dem = double.tryParse(val) ?? 0.0;
                                    notifier.updateRowInputs(
                                      row.id,
                                      demand: dem,
                                    );
                                  },
                                ),
                              ),

                              // Payable (Direct entry like days field)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey(
                                    'payable_${row.id}_${row.payable}_${row.isPayableOverridden}',
                                  ),
                                  initialValue: _fmt(row.currentAmt),
                                  width: 75,
                                  isReadOnly: isReadOnly,
                                  isBold: true,
                                  borderColor: row.isPayableOverridden
                                      ? Colors.amber[700]
                                      : null,
                                  backgroundColor: row.isPayableOverridden
                                      ? Colors.amber.withValues(alpha: 0.12)
                                      : null,
                                  onCommitted: (val) {
                                    if (val.isEmpty) {
                                      notifier.setRowOverride(
                                        row.id,
                                        'payable',
                                        null,
                                      );
                                    } else {
                                      final d = double.tryParse(val);
                                      if (d != null) {
                                        notifier.setRowOverride(
                                          row.id,
                                          'payable',
                                          d,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),

                              // Overtime (Editable input)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey('overtime_${row.id}'),
                                  initialValue: row.overtime > 0
                                      ? row.overtime.toStringAsFixed(0)
                                      : '',
                                  width: 65,
                                  isReadOnly: isReadOnly,
                                  onCommitted: (val) {
                                    final ot = double.tryParse(val) ?? 0.0;
                                    notifier.updateRowInputs(
                                      row.id,
                                      overtime: ot,
                                    );
                                  },
                                ),
                              ),

                              // Total (Highlighted in green like reference sheet)
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D32),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _fmt(row.total),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),

                              // Sync Status Dot
                              DataCell(_buildStatusDot(status)),
                            ],
                          );
                        }),

                        // ── Grand Totals Sticky Bottom Row ──────────────
                        DataRow(
                          color: WidgetStateProperty.all(
                            const Color(0xFFECEFF1),
                          ),
                          cells: [
                            const DataCell(
                              Text(
                                'TOTAL',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${state.rows.length} Workers',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                state.totalDays.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const DataCell(Text('—')),
                            DataCell(
                              Text(
                                _fmt(state.totalSalary),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                _fmt(state.totalAdvance),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                _fmt(state.totalCurrent),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                _fmt(state.totalDemand),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                _fmt(state.totalPayable),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                _fmt(state.totalOvertime),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B5E20),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _fmt(state.grandTotal),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const DataCell(SizedBox.shrink()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDot(RowSaveStatus status) {
    switch (status) {
      case RowSaveStatus.saving:
        return const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case RowSaveStatus.saved:
        return const Icon(Icons.check_circle, color: Colors.green, size: 16);
      case RowSaveStatus.error:
        return const Icon(Icons.error, color: Colors.red, size: 16);
      case RowSaveStatus.idle:
        return const SizedBox.shrink();
    }
  }

  Widget _buildKpiCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
    bool highlight = false,
    VoidCallback? onTap,
  }) {
    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlight ? color.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight
              ? color.withValues(alpha: 0.3)
              : const Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: highlight ? color : AppColors.textBlack,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: card,
      );
    }
    return card;
  }

  void _editCashGivenDialog(
    BuildContext context,
    double currentAmount,
    String? currentOperator,
  ) {
    final amountCtrl = TextEditingController(
      text: currentAmount > 0 ? currentAmount.toStringAsFixed(0) : '',
    );
    final opCtrl = TextEditingController(text: currentOperator ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Cash Handed Over'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: opCtrl,
                decoration: const InputDecoration(
                  labelText: 'Supervisor / Cash Recipient',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount Handed Over (PKR)',
                  prefixText: '₨ ',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
              ref
                  .read(payrollSheetDetailProvider(widget.sheetId).notifier)
                  .updateSheetMetadata(
                    operatorName: opCtrl.text.trim().isEmpty
                        ? null
                        : opCtrl.text.trim(),
                    amountGiven: amt,
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SpreadsheetCellInput extends StatefulWidget {
  final String initialValue;
  final double width;
  final bool isReadOnly;
  final ValueChanged<String> onCommitted;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool isBold;

  const _SpreadsheetCellInput({
    super.key,
    required this.initialValue,
    required this.width,
    required this.onCommitted,
    this.isReadOnly = false,
    this.backgroundColor,
    this.borderColor,
    this.isBold = false,
  });

  @override
  State<_SpreadsheetCellInput> createState() => _SpreadsheetCellInputState();
}

class _SpreadsheetCellInputState extends State<_SpreadsheetCellInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant _SpreadsheetCellInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _commit();
    }
  }

  void _commit() {
    widget.onCommitted(_controller.text.trim());
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReadOnly) {
      return SizedBox(
        width: widget.width,
        child: Text(
          widget.initialValue.isEmpty ? '—' : widget.initialValue,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 13,
            fontWeight: widget.isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: 32,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 13,
          fontWeight: widget.isBold ? FontWeight.bold : FontWeight.w500,
        ),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          isDense: true,
          hintText: '0',
          hintStyle: const TextStyle(color: Colors.black26),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: widget.borderColor ?? const Color(0xFFCFD8DC),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        onFieldSubmitted: (val) => _commit(),
      ),
    );
  }
}
