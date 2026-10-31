import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/core/theme/app_colors.dart';
import '../providers/payroll_providers.dart';

class OvertimeSheetView extends ConsumerStatefulWidget {
  final String sheetId;

  const OvertimeSheetView({super.key, required this.sheetId});

  @override
  ConsumerState<OvertimeSheetView> createState() => _OvertimeSheetViewState();
}

class _OvertimeSheetViewState extends ConsumerState<OvertimeSheetView> {
  final _currencyFormat = NumberFormat('#,##0');

  String _fmt(double val) {
    if (val == 0.0) return '—';
    return _currencyFormat.format(val);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(payrollSheetDetailProvider(widget.sheetId));
    final notifier = ref.read(payrollSheetDetailProvider(widget.sheetId).notifier);

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
      return const Scaffold(
        body: Center(child: Text('Sheet not found')),
      );
    }

    final isReadOnly = sheet.isFinalized;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
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
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFFA000)),
                  ),
                  child: const Text(
                    'OVERTIME',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                      color: sheet.isFinalized ? Colors.green[800] : Colors.blue[800],
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Finalize Overtime Sheet'),
                      content: const Text(
                        'Are you sure you want to finalize this Overtime sheet? Once finalized, entries are locked.',
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
                  subtitle: sheet.operatorName != null ? 'To: ${sheet.operatorName}' : null,
                  onTap: isReadOnly
                      ? null
                      : () => _editCashGivenDialog(context, sheet.amountGiven, sheet.operatorName),
                ),
                const SizedBox(width: 14),
                _buildKpiCard(
                  'Remaining Balance',
                  '₨ ${_fmt(state.balance)}',
                  Icons.balance,
                  state.balance >= 0 ? Colors.teal[700]! : Colors.red[700]!,
                ),
                const SizedBox(width: 14),
                _buildKpiCard(
                  'Total Overtime Days',
                  '${state.totalDays.toStringAsFixed(1)} Days',
                  Icons.calendar_today,
                  Colors.amber[800]!,
                ),
                const SizedBox(width: 14),
                _buildKpiCard(
                  'Total Overtime Hours',
                  '${state.totalHours.toStringAsFixed(1)} Hrs',
                  Icons.more_time,
                  Colors.deepOrange[700]!,
                ),
              ],
            ),
          ),

          // ── Yellow Reference Sheet Banner ─────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEB3B),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border.all(color: const Color(0xFFFBC02D), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(sheet.cutoffDate),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                ),
                Text(
                  sheet.company.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.5, color: Colors.black),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        sheet.category,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9C4),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFBC02D)),
                      ),
                      child: const Text(
                        'OverTime',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Color(0xFFE65100)),
                      ),
                    ),
                  ],
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
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
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFFFFDE7)),
                      headingRowHeight: 46,
                      dataRowMinHeight: 46,
                      dataRowMaxHeight: 52,
                      columnSpacing: 18,
                      horizontalMargin: 16,
                      columns: const [
                        DataColumn(label: Text('Sr.#', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(numeric: true, label: Text('Days', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(numeric: true, label: Text('Hours', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(numeric: true, label: Text('Salary/Day', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(numeric: true, label: Text('Day OT', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(numeric: true, label: Text('Hour OT', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(numeric: true, label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(numeric: true, label: Text('Paid Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Sync', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: [
                        ...state.rows.asMap().entries.map((entry) {
                          final index = entry.key;
                          final row = entry.value;
                          final status = state.rowStatuses[row.id] ?? RowSaveStatus.idle;
                          final isZero = row.isZero;

                          // Colors matching reference sheet:
                          // Amber background on Sr.#, Name & Remarks when Zero
                          final zeroBgColor = const Color(0xFFFFECB3);

                          return DataRow(
                            color: WidgetStateProperty.resolveWith((states) {
                              if (index.isOdd) return const Color(0xFFFAFAFA);
                              return Colors.white;
                            }),
                            cells: [
                              // Sr.#
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isZero ? zeroBgColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: isZero ? const Color(0xFF8D6E63) : AppColors.textGrey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              // Name
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isZero ? zeroBgColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: SizedBox(
                                    width: 160,
                                    child: Text(
                                      row.nameSnapshot,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: isZero ? const Color(0xFF5D4037) : AppColors.textBlack,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),

                              // Overtime Days (Editable input)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey('ot_days_${row.id}'),
                                  initialValue: row.days > 0 ? (row.days % 1 == 0 ? row.days.toInt().toString() : row.days.toString()) : '',
                                  width: 55,
                                  isReadOnly: isReadOnly,
                                  onCommitted: (val) {
                                    final d = double.tryParse(val) ?? 0.0;
                                    notifier.updateRowInputs(row.id, days: d);
                                  },
                                ),
                              ),

                              // Overtime Hours (Editable input, e.g. 3.5, 5)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey('ot_hours_${row.id}'),
                                  initialValue: row.hours > 0 ? (row.hours % 1 == 0 ? row.hours.toInt().toString() : row.hours.toString()) : '',
                                  width: 60,
                                  backgroundColor: const Color(0xFFFFF3E0),
                                  borderColor: const Color(0xFFFFB74D),
                                  isReadOnly: isReadOnly,
                                  onCommitted: (val) {
                                    final h = double.tryParse(val) ?? 0.0;
                                    notifier.updateRowInputs(row.id, hours: h);
                                  },
                                ),
                              ),

                              // Salary/Day (Editable rate)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey('ot_per_day_${row.id}_${row.perDay}'),
                                  initialValue: row.perDay > 0 ? (row.perDay % 1 == 0 ? row.perDay.toInt().toString() : row.perDay.toStringAsFixed(1)) : '',
                                  width: 70,
                                  isReadOnly: isReadOnly,
                                  onCommitted: (val) {
                                    final rate = double.tryParse(val) ?? 0.0;
                                    notifier.updateRowInputs(row.id, perDay: rate);
                                  },
                                ),
                              ),

                              // Day OT Amount (Computed = days * perDay)
                              DataCell(
                                Text(
                                  _fmt(row.dayAmount),
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                              ),

                              // Hour OT Amount (Computed = hours * (perDay / 8))
                              DataCell(
                                Text(
                                  _fmt(row.hourAmount),
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                              ),

                              // Total (Computed = Day OT + Hour OT)
                              DataCell(
                                Text(
                                  _fmt(row.total),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),

                              // Paid Amount (Editable override)
                              DataCell(
                                _SpreadsheetCellInput(
                                  key: ValueKey('paid_amt_${row.id}_${row.paidAmount}_${row.isPayableOverridden}'),
                                  initialValue: row.paidAmount > 0 ? row.paidAmount.toStringAsFixed(0) : '',
                                  width: 80,
                                  isReadOnly: isReadOnly,
                                  isBold: true,
                                  borderColor: row.isPayableOverridden ? Colors.amber[800] : null,
                                  backgroundColor: row.isPayableOverridden
                                      ? Colors.amber.withValues(alpha: 0.15)
                                      : null,
                                  onCommitted: (val) {
                                    if (val.isEmpty) {
                                      notifier.setRowOverride(row.id, 'payable', null);
                                    } else {
                                      final d = double.tryParse(val);
                                      if (d != null) {
                                        notifier.setRowOverride(row.id, 'payable', d);
                                      }
                                    }
                                  },
                                ),
                              ),

                              // Remarks Badge (Green "Paid" or Amber "Zero")
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isZero ? const Color(0xFFFFB300) : const Color(0xFF2E7D32),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isZero ? 'Zero' : 'Paid',
                                    style: TextStyle(
                                      color: isZero ? Colors.black87 : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),

                              // Sync Status Dot
                              DataCell(_buildStatusDot(status)),
                            ],
                          );
                        }),

                        // ── Totals Bottom Sticky Row ────────────────────
                        DataRow(
                          color: WidgetStateProperty.all(const Color(0xFFFFF9C4)),
                          cells: [
                            const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('${state.rows.length} Workers', style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(state.totalDays.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('${state.totalHours.toStringAsFixed(1)} h', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE65100)))),
                            const DataCell(Text('—')),
                            DataCell(Text(_fmt(state.totalDayAmount), style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_fmt(state.totalHourAmount), style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_fmt(state.grandTotal), style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '₨ ${_fmt(state.totalPaidAmount)}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ),
                            const DataCell(Text('')),
                            const DataCell(Text('')),
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
        return const Icon(Icons.check_circle, size: 16, color: Colors.green);
      case RowSaveStatus.error:
        return const Icon(Icons.error, size: 16, color: Colors.red);
      case RowSaveStatus.idle:
        return const SizedBox(width: 16);
    }
  }

  Widget _buildKpiCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool highlight = false,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: highlight ? color.withValues(alpha: 0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: highlight ? color.withValues(alpha: 0.3) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: highlight ? color : AppColors.textBlack,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editCashGivenDialog(BuildContext context, double currentAmt, String? currentOp) {
    final amtController = TextEditingController(
      text: currentAmt > 0 ? currentAmt.toStringAsFixed(0) : '',
    );
    final opController = TextEditingController(text: currentOp ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Update Cash Handed Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: opController,
              decoration: const InputDecoration(
                labelText: 'Handed Over To (Supervisor)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amtController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: const InputDecoration(
                labelText: 'Cash Amount (PKR)',
                prefixText: '₨ ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
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
            onPressed: () async {
              final newAmt = double.tryParse(amtController.text.trim()) ?? 0.0;
              final newOp = opController.text.trim().isEmpty ? null : opController.text.trim();
              Navigator.pop(ctx);
              await ref.read(payrollSheetDetailProvider(widget.sheetId).notifier).updateSheetMetadata(
                    operatorName: newOp,
                    amountGiven: newAmt,
                  );
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
  final bool isBold;
  final Color? backgroundColor;
  final Color? borderColor;
  final ValueChanged<String> onCommitted;

  const _SpreadsheetCellInput({
    super.key,
    required this.initialValue,
    required this.width,
    required this.onCommitted,
    this.isReadOnly = false,
    this.isBold = false,
    this.backgroundColor,
    this.borderColor,
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
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _commit();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SpreadsheetCellInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && !_focusNode.hasFocus) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commit() {
    final text = _controller.text.trim();
    if (text != widget.initialValue) {
      widget.onCommitted(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReadOnly) {
      return SizedBox(
        width: widget.width,
        child: Text(
          _controller.text.isEmpty ? '—' : _controller.text,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: 34,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
        textAlign: TextAlign.right,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => _commit(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: widget.isBold ? FontWeight.bold : FontWeight.w500,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: '0',
          hintStyle: const TextStyle(color: Colors.black26),
          filled: widget.backgroundColor != null,
          fillColor: widget.backgroundColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
      ),
    );
  }
}
