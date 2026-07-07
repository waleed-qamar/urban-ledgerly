// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../domain/entities/invoice_entity.dart';

// class InvoiceViewDialog extends StatelessWidget {
//   final InvoiceEntity invoice;
//   final String clientName;
//   final String supplierName;
//   final Map<int, String> productNames;
//   final Map<int, String> setNames;

//   const InvoiceViewDialog({
//     super.key,
//     required this.invoice,
//     required this.clientName,
//     required this.supplierName,
//     this.productNames = const {},
//     this.setNames = const {},
//   });

//   static String _fmt(double v) =>
//       NumberFormat.decimalPattern('en_IN').format(v);

//   @override
//   Widget build(BuildContext context) {
//     final isDispatched = invoice.status == 'dispatched';

//     return Dialog(
//       backgroundColor: AppColors.textWhite,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       child: SizedBox(
//         width: 700,
//         child: Padding(
//           padding: const EdgeInsets.all(28),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Header ─────────────────────────────────────────────────
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           invoice.invoiceNumber,
//                           style: Theme.of(context).textTheme.headlineSmall
//                               ?.copyWith(fontWeight: FontWeight.w800),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Issued: ${DateFormat('dd MMM yyyy').format(invoice.issueDate)}',
//                           style: TextStyle(color: Colors.grey.shade600),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Status badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isDispatched
//                           ? Colors.green.shade50
//                           : Colors.orange.shade50,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                         color: isDispatched
//                             ? Colors.green.shade300
//                             : Colors.orange.shade300,
//                       ),
//                     ),
//                     child: Text(
//                       isDispatched ? 'DISPATCHED' : 'UNDISPATCHED',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                         color: isDispatched
//                             ? Colors.green.shade700
//                             : Colors.orange.shade700,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.close),
//                   ),
//                 ],
//               ),
//               const Divider(height: 28),

//               // ── Info grid ──────────────────────────────────────────────
//               Wrap(
//                 spacing: 12,
//                 runSpacing: 12,
//                 children: [
//                   _InfoChip(
//                     label: 'Client',
//                     value: clientName,
//                     icon: Icons.person_outline,
//                   ),
//                   _InfoChip(
//                     label: 'Supplier',
//                     value: supplierName,
//                     icon: Icons.business_outlined,
//                   ),
//                   _InfoChip(
//                     label: 'Order ID',
//                     value: '#${invoice.orderId}',
//                     icon: Icons.receipt_long_outlined,
//                   ),
//                   if (invoice.po?.isNotEmpty == true)
//                     _InfoChip(
//                       label: 'PO',
//                       value: invoice.po!,
//                       icon: Icons.tag_outlined,
//                     ),
//                   _InfoChip(
//                     label: 'Representative',
//                     value: invoice.representative,
//                     icon: Icons.badge_outlined,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // ── Items table ────────────────────────────────────────────
//               if (invoice.items.isNotEmpty) ...[
//                 const Text(
//                   'Items',
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
//                 ),
//                 const SizedBox(height: 8),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Table(
//                     columnWidths: const {
//                       0: FlexColumnWidth(3),
//                       1: FlexColumnWidth(1.5),
//                       2: FlexColumnWidth(2),
//                       3: FlexColumnWidth(2),
//                     },
//                     border: TableBorder(
//                       horizontalInside: BorderSide(
//                         color: AppColors.dividerColor.withValues(alpha: 0.6),
//                       ),
//                     ),
//                     children: [
//                       TableRow(
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFF1F1F1),
//                         ),
//                         children: [
//                           _TableHeader('Product'),
//                           _TableHeader('Qty'),
//                           _TableHeader('Unit Price'),
//                           _TableHeader('Total'),
//                         ],
//                       ),
//                       ...invoice.items.map(
//                         (item) => TableRow(
//                           children: [
//                             _TableCell(
//                               item.isSet
//                                   ? (setNames[item.setId] ??
//                                         'Set #${item.setId}')
//                                   : (productNames[item.productId] ??
//                                         'Product #${item.productId}'),
//                             ),
//                             _TableCell(item.quantity.toStringAsFixed(0)),
//                             _TableCell('PKR ${_fmt(item.unitPrice)}'),
//                             _TableCell('PKR ${_fmt(item.totalPrice)}'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],

//               // ── Totals ─────────────────────────────────────────────────
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Container(
//                   width: 280,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF7F1FA),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Column(
//                     children: [
//                       _TotalRow('Sub Total', 'PKR ${_fmt(invoice.subTotal)}'),
//                       const SizedBox(height: 6),
//                       _TotalRow(
//                         'Shipping',
//                         'PKR ${_fmt(invoice.shippingCost)}',
//                       ),
//                       const SizedBox(height: 6),
//                       _TotalRow(
//                         'Tax (${invoice.taxPercent.toStringAsFixed(0)}%)',
//                         'PKR ${_fmt(invoice.taxAmount)}',
//                       ),
//                       const Divider(height: 16),
//                       _TotalRow(
//                         'Grand Total',
//                         'PKR ${_fmt(invoice.grandTotal)}',
//                         bold: true,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _InfoChip extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;

//   const _InfoChip({
//     required this.label,
//     required this.value,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: AppColors.dividerColor.withValues(alpha: 0.5),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: AppColors.textGrey),
//           const SizedBox(width: 6),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey.shade500,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TableHeader extends StatelessWidget {
//   final String label;
//   const _TableHeader(this.label);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       child: Text(
//         label,
//         style: const TextStyle(
//           fontWeight: FontWeight.w700,
//           color: AppColors.textBlack87,
//         ),
//       ),
//     );
//   }
// }

// class _TableCell extends StatelessWidget {
//   final String value;
//   const _TableCell(this.value);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//       child: Text(
//         value,
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           color: AppColors.textBlack,
//         ),
//       ),
//     );
//   }
// }

// class _TotalRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool bold;

//   const _TotalRow(this.label, this.value, {this.bold = false});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: bold ? AppColors.textBlack : AppColors.textGrey,
//             fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
//             fontSize: bold ? 16 : 14,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             color: bold ? AppColors.primaryDark : AppColors.textBlack,
//             fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
//             fontSize: bold ? 16 : 14,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:ledgerly/core/widgets/audit_log_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/invoice_entity.dart';

class InvoiceViewDialog extends StatelessWidget {
  final InvoiceEntity invoice;
  final String clientName;
  final String supplierName;
  final Map<int, String> productNames;
  final Map<int, String> setNames;

  const InvoiceViewDialog({
    super.key,
    required this.invoice,
    required this.clientName,
    required this.supplierName,
    this.productNames = const {},
    this.setNames = const {},
  });

  static String _fmt(double v) =>
      NumberFormat.decimalPattern('en_IN').format(v);

  @override
  Widget build(BuildContext context) {
    final isDispatched = invoice.status == 'dispatched';

    return Dialog(
      backgroundColor: AppColors.textWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // ── Header ─────────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.invoiceNumber,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Issued: ${DateFormat('dd MMM yyyy').format(invoice.issueDate)}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        invoice.status != 'dispatched'
                            ? const SizedBox()
                            : Text(
                                'Dispatch: ${DateFormat('dd MMM yyyy').format(invoice.dispatchedAt)}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDispatched
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDispatched
                            ? Colors.green.shade300
                            : Colors.orange.shade300,
                      ),
                    ),
                    child: Text(
                      isDispatched ? 'DISPATCHED' : 'UNDISPATCHED',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDispatched
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 28),

              // ── Info grid ──────────────────────────────────────────────
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _InfoChip(
                    label: 'Client',
                    value: clientName,
                    icon: Icons.person_outline,
                  ),
                  _InfoChip(
                    label: 'Supplier',
                    value: supplierName,
                    icon: Icons.business_outlined,
                  ),
                  _InfoChip(
                    label: 'Order ID',
                    value: '#${invoice.orderId}',
                    icon: Icons.receipt_long_outlined,
                  ),
                  if (invoice.po?.isNotEmpty == true)
                    _InfoChip(
                      label: 'PO',
                      value: invoice.po!,
                      icon: Icons.tag_outlined,
                    ),
                  _InfoChip(
                    label: 'Representative',
                    value: invoice.representative,
                    icon: Icons.badge_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Items table ────────────────────────────────────────────
              if (invoice.items.isNotEmpty) ...[
                const Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                    },
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: AppColors.dividerColor.withValues(alpha: 0.6),
                      ),
                    ),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F1F1),
                        ),
                        children: [
                          _TableHeader('Product'),
                          _TableHeader('Qty'),
                          _TableHeader('Unit Price'),
                          _TableHeader('Total'),
                        ],
                      ),
                      ...invoice.items.map(
                        (item) => TableRow(
                          children: [
                            _TableCell(
                              item.isSet
                                  ? (setNames[item.setId] ??
                                        'Set #${item.setId}')
                                  : (productNames[item.productId] ??
                                        'Product #${item.productId}'),
                            ),
                            _TableCell(item.quantity.toStringAsFixed(0)),
                            _TableCell('PKR ${_fmt(item.unitPrice)}'),
                            _TableCell('PKR ${_fmt(item.totalPrice)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Totals ─────────────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F1FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _TotalRow('Sub Total', 'PKR ${_fmt(invoice.subTotal)}'),
                      const SizedBox(height: 6),
                      _TotalRow(
                        'Shipping',
                        'PKR ${_fmt(invoice.shippingCost)}',
                      ),
                      const SizedBox(height: 6),
                      _TotalRow(
                        'Tax (${invoice.taxPercent.toStringAsFixed(0)}%)',
                        'PKR ${_fmt(invoice.taxAmount)}',
                      ),
                      const Divider(height: 16),
                      _TotalRow(
                        'Grand Total',
                        'PKR ${_fmt(invoice.grandTotal)}',
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 32),
              const Text(
                'Activity History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textBlack),
              ),
              const SizedBox(height: 16),
              AuditLogListWidget(
                tableName: 'invoices',
                recordId: invoice.id.toString(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ),
  );
}
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String label;
  const _TableHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textBlack87,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String value;
  const _TableCell(this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textBlack,
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _TotalRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? AppColors.textBlack : AppColors.textGrey,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            fontSize: bold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: bold ? AppColors.primaryDark : AppColors.textBlack,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
            fontSize: bold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
