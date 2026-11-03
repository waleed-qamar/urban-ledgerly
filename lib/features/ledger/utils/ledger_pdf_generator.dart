import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../invoices/domain/entities/invoice_entity.dart';
import '../../orders/domain/entities/order_entity.dart';
import '../../procurement/domain/entities/procurement_entity.dart';
import '../../receipts/domain/entities/disbursement_record.dart';
import '../../receipts/domain/entities/receipt_entity.dart';
import '../domain/entities/ledger_entity.dart';

enum LedgerPdfStyle {
  detailed, // 10 columns: Date, Vch No, Ref, Description, QTY, Weight, Rate, Debit, Credit, Balance (Itemized with subtotals & summary cards)
  standard, // 6 columns: Voucher #, Date, Narration, Debit, Credit, Balance (Summary statement grid)
}

class LedgerPdfGenerator {
  // Financial UI colors for high readability on screen and print
  static final PdfColor _debitColor = PdfColor.fromHex('#B91C1C'); // Crisp deep Crimson
  static final PdfColor _creditColor = PdfColor.fromHex('#047857'); // Crisp deep Emerald
  static final PdfColor _zeroColor = PdfColor.fromHex('#9CA3AF'); // Muted Grey for 0

  static String _formatAmount(double amount) {
    if (amount == 0) return '0';
    if (amount % 1 == 0) {
      return NumberFormat('#,##0').format(amount);
    } else {
      return NumberFormat('#,##0.00').format(amount);
    }
  }

  static String _formatDecimal(double amount) {
    if (amount == 0) return '';
    return NumberFormat('#,##0.00').format(amount);
  }

  static String _formatQty(num qty) {
    if (qty == 0) return '';
    if (qty % 1 == 0) {
      return NumberFormat('#,##0').format(qty);
    }
    return NumberFormat('#,##0.00').format(qty);
  }

  static String _formatBalance(double balance, PartyType partyType) {
    if (balance == 0) return '0';
    final formatted = NumberFormat('#,##0').format(balance.abs());
    final bool isCredit;
    if (partyType == PartyType.client) {
      isCredit = balance < 0;
    } else {
      isCredit = balance >= 0;
    }
    final suffix = isCredit ? 'Cr.' : 'Dr.';
    return '$formatted $suffix';
  }

  /// Generates the raw PDF bytes for either previewing or downloading.
  static Future<Uint8List> generatePdfBytes({
    required int partyId,
    required String partyName,
    required PartyType partyType,
    LedgerPdfStyle style = LedgerPdfStyle.detailed,
    String? address,
    String? contact,
    String? email,
    String? city,
    String? web,
    String companyName = 'URBAN COMPOSITES',
    String companyCity = 'GUJRANWALA',
    required DateTime fromDate,
    required DateTime toDate,
    required List<LedgerEntity> allEntries,
    List<ProcurementEntity>? procurements,
    Map<int, String>? rawMaterialsMap,
    List<DisbursementRecord>? disbursements,
    List<InvoiceEntity>? invoices,
    List<ReceiptEntity>? receipts,
    Map<int, String>? productsMap,
    Map<int, String>? productSetsMap,
    List<OrderEntity>? orders,
  }) async {
    final doc = pw.Document();

    final fromStart = DateTime(
      fromDate.year,
      fromDate.month,
      fromDate.day,
      0,
      0,
      0,
    );
    final toEnd = DateTime(
      toDate.year,
      toDate.month,
      toDate.day,
      23,
      59,
      59,
      999,
    );

    final sortedEntries = List<LedgerEntity>.from(allEntries)
      ..sort((a, b) {
        final cmp = a.entryDate.compareTo(b.entryDate);
        if (cmp != 0) return cmp;
        return a.id.compareTo(b.id);
      });

    // 1. Calculate previous balance
    double previousBalance = 0;
    final periodEntries = <LedgerEntity>[];

    for (final entry in sortedEntries) {
      if (entry.entryDate.isBefore(fromStart)) {
        if (partyType == PartyType.client) {
          previousBalance += (entry.entryType == EntryType.debit
              ? entry.amount
              : -entry.amount);
        } else {
          previousBalance += (entry.entryType == EntryType.credit
              ? entry.amount
              : -entry.amount);
        }
      } else if (!entry.entryDate.isAfter(toEnd)) {
        periodEntries.add(entry);
      }
    }

    // Lookup caches
    final procMap = <String, ProcurementEntity>{};
    if (procurements != null) {
      for (final p in procurements) {
        if (p.id != null) {
          procMap[p.id.toString()] = p;
          procMap['PRC-${p.id}'] = p;
        }
      }
    }

    final disbMap = <String, DisbursementRecord>{};
    if (disbursements != null) {
      for (final d in disbursements) {
        disbMap[d.id.toString()] = d;
        disbMap[d.disbursementNumber.trim()] = d;
      }
    }

    final invMap = <String, InvoiceEntity>{};
    if (invoices != null) {
      for (final inv in invoices) {
        if (inv.id != null) invMap[inv.id.toString()] = inv;
        invMap[inv.invoiceNumber.trim()] = inv;
      }
    }

    final recMap = <String, ReceiptEntity>{};
    if (receipts != null) {
      for (final r in receipts) {
        if (r.id != null) recMap[r.id.toString()] = r;
        if (r.receiptNumber != null) {
          final trimmed = r.receiptNumber!.trim();
          recMap[trimmed] = r;
          recMap[trimmed.toUpperCase()] = r;
          recMap[trimmed.replaceAll('RCPT-', '')] = r;
          recMap[trimmed.replaceAll('REC-', '')] = r;
          final noZeros = trimmed
              .replaceAll('RCPT-', '')
              .replaceAll('REC-', '')
              .replaceFirst(RegExp(r'^0+'), '');
          if (noZeros.isNotEmpty) recMap[noZeros] = r;
        }
      }
    }

    final ordMap = <String, OrderEntity>{};
    if (orders != null) {
      for (final o in orders) {
        if (o.id != null) ordMap[o.id.toString()] = o;
      }
    }

    if (style == LedgerPdfStyle.detailed) {
      _buildDetailedPdf(
        doc: doc,
        partyId: partyId,
        partyName: partyName,
        partyType: partyType,
        address: address,
        contact: contact,
        email: email,
        city: city,
        web: web,
        companyName: companyName,
        companyCity: companyCity,
        fromDate: fromDate,
        toDate: toDate,
        previousBalance: previousBalance,
        periodEntries: periodEntries,
        procMap: procMap,
        disbMap: disbMap,
        invMap: invMap,
        recMap: recMap,
        ordMap: ordMap,
        rawMaterialsMap: rawMaterialsMap,
        productsMap: productsMap,
        productSetsMap: productSetsMap,
      );
    } else {
      _buildStandardPdf(
        doc: doc,
        partyId: partyId,
        partyName: partyName,
        partyType: partyType,
        address: address,
        contact: contact,
        email: email,
        city: city,
        web: web,
        companyName: companyName,
        companyCity: companyCity,
        fromDate: fromDate,
        toDate: toDate,
        previousBalance: previousBalance,
        periodEntries: periodEntries,
        procMap: procMap,
        disbMap: disbMap,
        invMap: invMap,
        recMap: recMap,
        rawMaterialsMap: rawMaterialsMap,
        productsMap: productsMap,
      );
    }

    final bytes = await doc.save();
    return Uint8List.fromList(bytes);
  }

  static Future<void> generateAndDownload({
    required int partyId,
    required String partyName,
    required PartyType partyType,
    LedgerPdfStyle style = LedgerPdfStyle.detailed,
    String? address,
    String? contact,
    String? email,
    String? city,
    String? web,
    String companyName = 'URBAN COMPOSITES',
    String companyCity = 'GUJRANWALA',
    required DateTime fromDate,
    required DateTime toDate,
    required List<LedgerEntity> allEntries,
    List<ProcurementEntity>? procurements,
    Map<int, String>? rawMaterialsMap,
    List<DisbursementRecord>? disbursements,
    List<InvoiceEntity>? invoices,
    List<ReceiptEntity>? receipts,
    Map<int, String>? productsMap,
    Map<int, String>? productSetsMap,
    List<OrderEntity>? orders,
  }) async {
    final bytes = await generatePdfBytes(
      partyId: partyId,
      partyName: partyName,
      partyType: partyType,
      style: style,
      address: address,
      contact: contact,
      email: email,
      city: city,
      web: web,
      companyName: companyName,
      companyCity: companyCity,
      fromDate: fromDate,
      toDate: toDate,
      allEntries: allEntries,
      procurements: procurements,
      rawMaterialsMap: rawMaterialsMap,
      disbursements: disbursements,
      invoices: invoices,
      receipts: receipts,
      productsMap: productsMap,
      productSetsMap: productSetsMap,
      orders: orders,
    );

    final sanitizedParty = partyName.replaceAll(
      RegExp(r'[^a-zA-Z0-9_\-]'),
      '_',
    );

    await FileSaver.instance.saveFile(
      name: '${sanitizedParty.toUpperCase()}_LEDGER',
      bytes: bytes,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }

  // ==========================================
  // DETAILED STYLE (Itemized, 10 columns)
  // ==========================================
  static void _buildDetailedPdf({
    required pw.Document doc,
    required int partyId,
    required String partyName,
    required PartyType partyType,
    String? address,
    String? contact,
    String? email,
    String? city,
    String? web,
    required String companyName,
    required String companyCity,
    required DateTime fromDate,
    required DateTime toDate,
    required double previousBalance,
    required List<LedgerEntity> periodEntries,
    required Map<String, ProcurementEntity> procMap,
    required Map<String, DisbursementRecord> disbMap,
    required Map<String, InvoiceEntity> invMap,
    required Map<String, ReceiptEntity> recMap,
    required Map<String, OrderEntity> ordMap,
    Map<int, String>? rawMaterialsMap,
    Map<int, String>? productsMap,
    Map<int, String>? productSetsMap,
  }) {
    double runningBalance = previousBalance;
    double totalDebit = 0;
    double totalCredit = 0;

    final tableRows = <pw.TableRow>[];

    // Table Header Row
    tableRows.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.white),
        children: [
          _cellSmall('Date', isBold: true, align: pw.TextAlign.center),
          _cellSmall('Vch. No.', isBold: true, align: pw.TextAlign.center),
          _cellSmall('Ref', isBold: true, align: pw.TextAlign.center),
          _cellSmall('Description', isBold: true, align: pw.TextAlign.left),
          _cellSmall('QTY', isBold: true, align: pw.TextAlign.right),
          _cellSmall('Weight', isBold: true, align: pw.TextAlign.right),
          _cellSmall('Rate', isBold: true, align: pw.TextAlign.right),
          _cellSmall('Debit', isBold: true, align: pw.TextAlign.right, color: _debitColor),
          _cellSmall('Credit', isBold: true, align: pw.TextAlign.right, color: _creditColor),
          _cellSmall('Balance', isBold: true, align: pw.TextAlign.right),
        ],
      ),
    );

    // Previous Balance Row
    if (previousBalance != 0) {
      final prevBalStr = _formatBalance(previousBalance, partyType);
      final prevBalColor = prevBalStr.contains('Cr.')
          ? _creditColor
          : (prevBalStr.contains('Dr.') ? _debitColor : PdfColors.black);

      tableRows.add(
        pw.TableRow(
          children: [
            _cellSmall(''),
            _cellSmall(''),
            _cellSmall(''),
            _cellSmall('Previous Balance', isBold: true),
            _cellSmall(''),
            _cellSmall(''),
            _cellSmall(''),
            _cellSmall(''),
            _cellSmall(''),
            _cellSmall(
              prevBalStr,
              isBold: true,
              align: pw.TextAlign.right,
              color: prevBalColor,
            ),
          ],
        ),
      );
    }

    final handledFareEntryIds = <int>{};

    for (final entry in periodEntries) {
      if (handledFareEntryIds.contains(entry.id)) continue;

      final isDebit = entry.entryType == EntryType.debit;
      final source = (entry.transactionSource ?? '').toLowerCase();
      final refId = entry.referenceId ?? '';
      final invNo = entry.invoiceNumber ?? '';
      final formattedDate = DateFormat('dd/MM/yyyy').format(entry.entryDate);

      if (partyType == PartyType.vendor) {
        // VENDOR HANDLING
        ProcurementEntity? matchingProc;
        if (source == 'procurement' || invNo.startsWith('PRC-')) {
          matchingProc =
              procMap[refId] ??
              procMap[invNo] ??
              procMap[invNo.replaceAll('PRC-', '')];
        }

        DisbursementRecord? matchingDisb;
        if (source == 'disbursement' || invNo.startsWith('DSB-')) {
          matchingDisb = disbMap[refId] ?? disbMap[invNo];
        }

        if (matchingProc != null && matchingProc.items.isNotEmpty) {
          final vch = matchingProc.id != null ? 'PRC-${matchingProc.id}' : invNo;
          final refVal = matchingProc.notes?.trim() ?? '';
          double subtotalQty = 0;
          double subtotalWeight = 0;
          double subtotalAmount = 0;

          for (int i = 0; i < matchingProc.items.length; i++) {
            final item = matchingProc.items[i];
            final matName = rawMaterialsMap?[item.rawMaterialId] ?? 'Raw Material #${item.rawMaterialId}';

            final itemAmt = item.total;
            subtotalQty += item.quantity;
            subtotalAmount += itemAmt;

            final itemDebit = isDebit ? itemAmt : 0.0;
            final itemCredit = isDebit ? 0.0 : itemAmt;
            totalDebit += itemDebit;
            totalCredit += itemCredit;
            runningBalance += (itemCredit - itemDebit);

            final balStr = _formatBalance(runningBalance, partyType);
            final balColor = balStr.contains('Cr.')
                ? _creditColor
                : (balStr.contains('Dr.') ? _debitColor : PdfColors.black);

            tableRows.add(
              pw.TableRow(
                children: [
                  _cellSmall(i == 0 ? formattedDate : '', align: pw.TextAlign.center),
                  _cellSmall(i == 0 ? vch : '', align: pw.TextAlign.center),
                  _cellSmall(i == 0 ? refVal : '', align: pw.TextAlign.center),
                  _cellSmall(matName, align: pw.TextAlign.left),
                  _cellSmall(_formatQty(item.quantity), align: pw.TextAlign.right),
                  _cellSmall('', align: pw.TextAlign.right),
                  _cellSmall(_formatDecimal(item.price), align: pw.TextAlign.right),
                  _cellSmall(
                    itemDebit > 0 ? _formatAmount(itemDebit) : '',
                    align: pw.TextAlign.right,
                    color: _debitColor,
                  ),
                  _cellSmall(
                    itemCredit > 0 ? _formatAmount(itemCredit) : '',
                    align: pw.TextAlign.right,
                    color: _creditColor,
                  ),
                  _cellSmall(
                    balStr,
                    align: pw.TextAlign.right,
                    color: balColor,
                  ),
                ],
              ),
            );
          }

          // Subtotal row under items
          tableRows.add(
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
                ),
              ),
              children: [
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(
                  _formatQty(subtotalQty),
                  isBold: true,
                  align: pw.TextAlign.right,
                ),
                _cellSmall(
                  _formatDecimal(subtotalWeight),
                  isBold: true,
                  align: pw.TextAlign.right,
                ),
                _cellSmall(''),
                _cellSmall(
                  isDebit ? _formatAmount(subtotalAmount) : '',
                  isBold: true,
                  align: pw.TextAlign.right,
                  color: _debitColor,
                ),
                _cellSmall(
                  isDebit ? '' : _formatAmount(subtotalAmount),
                  isBold: true,
                  align: pw.TextAlign.right,
                  color: _creditColor,
                ),
                _cellSmall(''),
              ],
            ),
          );
        } else if (matchingDisb != null) {
          // Disbursement payment
          final accRef = matchingDisb.accountNo?.trim();
          final vch = (accRef != null && accRef.isNotEmpty)
              ? accRef
              : matchingDisb.disbursementNumber;

          final disbRem = matchingDisb.remarks?.trim() ?? '';
          final entryRem = entry.remarks?.trim() ?? '';
          final desc = disbRem.isNotEmpty
              ? disbRem
              : (entryRem.isNotEmpty
                  ? entryRem
                  : '${matchingDisb.paymentMethod} Payment');

          final itemDebit = entry.amount;
          totalDebit += itemDebit;
          runningBalance -= itemDebit;

          final balStr = _formatBalance(runningBalance, partyType);
          final balColor = balStr.contains('Cr.')
              ? _creditColor
              : (balStr.contains('Dr.') ? _debitColor : PdfColors.black);

          tableRows.add(
            pw.TableRow(
              children: [
                _cellSmall(formattedDate, align: pw.TextAlign.center),
                _cellSmall(vch, align: pw.TextAlign.center),
                _cellSmall(''),
                _cellSmall(desc, align: pw.TextAlign.left),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(
                  _formatAmount(itemDebit),
                  isBold: true,
                  align: pw.TextAlign.right,
                  color: _debitColor,
                ),
                _cellSmall(''),
                _cellSmall(
                  balStr,
                  align: pw.TextAlign.right,
                  color: balColor,
                ),
              ],
            ),
          );
        } else {
          // Manual vendor entry or fallback
          final vch = invNo.isNotEmpty ? invNo : refId;
          final entryRem = entry.remarks?.trim() ?? '';
          final desc = entryRem.isNotEmpty
              ? entryRem
              : (entry.paymentMethod?.isNotEmpty == true
                  ? '${entry.paymentMethod} Payment'
                  : (isDebit ? 'Debit Entry' : 'Credit Entry'));

          final itemDebit = isDebit ? entry.amount : 0.0;
          final itemCredit = isDebit ? 0.0 : entry.amount;
          totalDebit += itemDebit;
          totalCredit += itemCredit;
          runningBalance += (itemCredit - itemDebit);

          final balStr = _formatBalance(runningBalance, partyType);
          final balColor = balStr.contains('Cr.')
              ? _creditColor
              : (balStr.contains('Dr.') ? _debitColor : PdfColors.black);

          tableRows.add(
            pw.TableRow(
              children: [
                _cellSmall(formattedDate, align: pw.TextAlign.center),
                _cellSmall(vch, align: pw.TextAlign.center),
                _cellSmall(''),
                _cellSmall(desc, align: pw.TextAlign.left),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(
                  itemDebit > 0 ? _formatAmount(itemDebit) : '',
                  isBold: itemDebit > 0,
                  align: pw.TextAlign.right,
                  color: _debitColor,
                ),
                _cellSmall(
                  itemCredit > 0 ? _formatAmount(itemCredit) : '',
                  isBold: itemCredit > 0,
                  align: pw.TextAlign.right,
                  color: _creditColor,
                ),
                _cellSmall(
                  balStr,
                  align: pw.TextAlign.right,
                  color: balColor,
                ),
              ],
            ),
          );
        }
      } else {
        // CLIENT HANDLING
        InvoiceEntity? matchingInv;
        if (source == 'invoice' || invNo.startsWith('INV-')) {
          matchingInv = invMap[refId] ?? invMap[invNo];
        }

        ReceiptEntity? matchingRec;
        if (source.contains('receipt') ||
            invNo.startsWith('REC-') ||
            invNo.startsWith('RCPT-')) {
          matchingRec =
              recMap[refId] ??
              recMap[invNo] ??
              recMap[invNo.replaceAll('RCPT-', '')] ??
              recMap[invNo.replaceAll('REC-', '')];
        }

        final isFare =
            refId.startsWith('invoice_fare:') ||
            (entry.remarks?.toLowerCase().contains('fare') ?? false);

        if (isFare) {
          final vch = matchingInv?.invoiceNumber ?? invNo;
          final refVal = matchingInv?.po ?? '';
          const desc = 'Fare (Ex factory)';

          final itemDebit = isDebit ? entry.amount : 0.0;
          final itemCredit = isDebit ? 0.0 : entry.amount;
          totalDebit += itemDebit;
          totalCredit += itemCredit;
          runningBalance += (itemDebit - itemCredit);

          final balStr = _formatBalance(runningBalance, partyType);
          final balColor = balStr.contains('Cr.')
              ? _creditColor
              : (balStr.contains('Dr.') ? _debitColor : PdfColors.black);

          tableRows.add(
            pw.TableRow(
              children: [
                _cellSmall(formattedDate, align: pw.TextAlign.center),
                _cellSmall(vch, align: pw.TextAlign.center),
                _cellSmall(refVal, align: pw.TextAlign.center),
                _cellSmall(desc, align: pw.TextAlign.left),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(
                  itemDebit > 0 ? _formatAmount(itemDebit) : '',
                  isBold: true,
                  align: pw.TextAlign.right,
                  color: _debitColor,
                ),
                _cellSmall(
                  itemCredit > 0 ? _formatAmount(itemCredit) : '',
                  isBold: true,
                  align: pw.TextAlign.right,
                  color: _creditColor,
                ),
                _cellSmall(
                  balStr,
                  align: pw.TextAlign.right,
                  color: balColor,
                ),
              ],
            ),
          );
        } else if (matchingInv != null && matchingInv.items.isNotEmpty) {
          final vch = matchingInv.invoiceNumber;
          final refVal = matchingInv.po?.trim() ?? '';
          double subtotalQty = 0;
          double subtotalAmount = 0;

          for (int i = 0; i < matchingInv.items.length; i++) {
            final item = matchingInv.items[i];
            String desc = item.description ?? '';
            if (desc.isEmpty) {
              if (item.isSet) {
                desc = productSetsMap?[item.setId] ?? 'Product Set';
              } else {
                desc = productsMap?[item.productId] ?? 'Product';
              }
            }

            final itemTotal = item.totalPrice;
            subtotalQty += item.quantity;
            subtotalAmount += itemTotal;

            final itemDebit = isDebit ? itemTotal : 0.0;
            final itemCredit = isDebit ? 0.0 : itemTotal;
            totalDebit += itemDebit;
            totalCredit += itemCredit;
            runningBalance += (itemDebit - itemCredit);

            final balStr = _formatBalance(runningBalance, partyType);
            final balColor = balStr.contains('Cr.')
                ? _creditColor
                : (balStr.contains('Dr.') ? _debitColor : PdfColors.black);

            tableRows.add(
              pw.TableRow(
                children: [
                  _cellSmall(i == 0 ? formattedDate : '', align: pw.TextAlign.center),
                  _cellSmall(i == 0 ? vch : '', align: pw.TextAlign.center),
                  _cellSmall(i == 0 ? refVal : '', align: pw.TextAlign.center),
                  _cellSmall(desc, align: pw.TextAlign.left),
                  _cellSmall(_formatQty(item.quantity), align: pw.TextAlign.right),
                  _cellSmall(''),
                  _cellSmall(_formatDecimal(item.unitPrice), align: pw.TextAlign.right),
                  _cellSmall(
                    itemDebit > 0 ? _formatAmount(itemDebit) : '',
                    align: pw.TextAlign.right,
                    color: _debitColor,
                  ),
                  _cellSmall(
                    itemCredit > 0 ? _formatAmount(itemCredit) : '',
                    align: pw.TextAlign.right,
                    color: _creditColor,
                  ),
                  _cellSmall(
                    balStr,
                    align: pw.TextAlign.right,
                    color: balColor,
                  ),
                ],
              ),
            );
          }

          // Subtotal row under invoice items
          tableRows.add(
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
                ),
              ),
              children: [
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(
                  _formatQty(subtotalQty),
                  isBold: true,
                  align: pw.TextAlign.right,
                ),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(
                  isDebit ? _formatAmount(subtotalAmount) : '',
                  isBold: true,
                  align: pw.TextAlign.right,
                  color: _debitColor,
                ),
                _cellSmall(
                  isDebit ? '' : _formatAmount(subtotalAmount),
                  isBold: true,
                  align: pw.TextAlign.right,
                  color: _creditColor,
                ),
                _cellSmall(''),
              ],
            ),
          );
        } else if (matchingRec != null) {
          // Client Receipt
          final accRef = matchingRec.accountNo?.trim();
          final vch = (accRef != null && accRef.isNotEmpty)
              ? accRef
              : (matchingRec.receiptNumber ?? invNo);

          final recRem = matchingRec.remarks?.trim() ?? '';
          final entryRem = entry.remarks?.trim() ?? '';
          final rawMethod = matchingRec.paymentMethod.trim().toLowerCase();
          final defaultMethod = switch (rawMethod) {
            'bank' => 'Bank Payment',
            'cash' => 'Cash Payment',
            'cheque' => 'Cheque Payment',
            _ => rawMethod.isNotEmpty
                ? '${rawMethod[0].toUpperCase()}${rawMethod.substring(1)} Payment'
                : 'Bank Payment',
          };
          final desc = recRem.isNotEmpty
              ? recRem
              : (entryRem.isNotEmpty ? entryRem : defaultMethod);

          final itemCredit = entry.amount;
          totalCredit += itemCredit;
          runningBalance -= itemCredit;

          final balStr = _formatBalance(runningBalance, partyType);
          final balColor = balStr.contains('Cr.')
              ? _creditColor
              : (balStr.contains('Dr.') ? _debitColor : PdfColors.black);

          tableRows.add(
            pw.TableRow(
              children: [
                _cellSmall(formattedDate, align: pw.TextAlign.center),
                _cellSmall(vch, align: pw.TextAlign.center),
                _cellSmall(''),
                _cellSmall(desc, align: pw.TextAlign.left),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(
                  _formatAmount(itemCredit),
                  isBold: true,
                  align: pw.TextAlign.right,
                  color: _creditColor,
                ),
                _cellSmall(
                  balStr,
                  align: pw.TextAlign.right,
                  color: balColor,
                ),
              ],
            ),
          );
        } else {
          // Manual client entry or fallback
          final vch = invNo.isNotEmpty ? invNo : refId;
          final entryRem = entry.remarks?.trim() ?? '';
          final desc = entryRem.isNotEmpty
              ? entryRem
              : (entry.paymentMethod?.isNotEmpty == true
                  ? '${entry.paymentMethod} Payment'
                  : (isDebit ? 'Debit Entry' : 'Bank Payment'));

          final itemDebit = isDebit ? entry.amount : 0.0;
          final itemCredit = isDebit ? 0.0 : entry.amount;
          totalDebit += itemDebit;
          totalCredit += itemCredit;
          runningBalance += (itemDebit - itemCredit);

          final balStr = _formatBalance(runningBalance, partyType);
          final balColor = balStr.contains('Cr.')
              ? _creditColor
              : (balStr.contains('Dr.') ? _debitColor : PdfColors.black);

          tableRows.add(
            pw.TableRow(
              children: [
                _cellSmall(formattedDate, align: pw.TextAlign.center),
                _cellSmall(vch, align: pw.TextAlign.center),
                _cellSmall(''),
                _cellSmall(desc, align: pw.TextAlign.left),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(''),
                _cellSmall(
                  itemDebit > 0 ? _formatAmount(itemDebit) : '',
                  isBold: itemDebit > 0,
                  align: pw.TextAlign.right,
                  color: _debitColor,
                ),
                _cellSmall(
                  itemCredit > 0 ? _formatAmount(itemCredit) : '',
                  isBold: itemCredit > 0,
                  align: pw.TextAlign.right,
                  color: _creditColor,
                ),
                _cellSmall(
                  balStr,
                  align: pw.TextAlign.right,
                  color: balColor,
                ),
              ],
            ),
          );
        }
      }
    }

    // Grand Total Row
    final totalBalStr = _formatBalance(runningBalance, partyType);
    final totalBalColor = totalBalStr.contains('Cr.')
        ? _creditColor
        : (totalBalStr.contains('Dr.') ? _debitColor : PdfColors.black);

    tableRows.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            top: pw.BorderSide(color: PdfColors.black, width: 0.8),
            bottom: pw.BorderSide(color: PdfColors.black, width: 0.8),
          ),
        ),
        children: [
          _cellSmall(''),
          _cellSmall(''),
          _cellSmall(''),
          _cellSmall('Total', isBold: true),
          _cellSmall(''),
          _cellSmall(''),
          _cellSmall(''),
          _cellSmall(
            _formatAmount(totalDebit),
            isBold: true,
            align: pw.TextAlign.right,
            color: totalDebit > 0 ? _debitColor : PdfColors.black,
          ),
          _cellSmall(
            _formatAmount(totalCredit),
            isBold: true,
            align: pw.TextAlign.right,
            color: totalCredit > 0 ? _creditColor : PdfColors.black,
          ),
          _cellSmall(
            totalBalStr,
            isBold: true,
            align: pw.TextAlign.right,
            color: totalBalColor,
          ),
        ],
      ),
    );

    const detailedColumnWidths = {
      0: pw.FixedColumnWidth(48), // Date
      1: pw.FixedColumnWidth(50), // Vch. No.
      2: pw.FixedColumnWidth(40), // Ref
      3: pw.FlexColumnWidth(2.6), // Description
      4: pw.FixedColumnWidth(28), // QTY
      5: pw.FixedColumnWidth(38), // Weight
      6: pw.FixedColumnWidth(42), // Rate
      7: pw.FixedColumnWidth(52), // Debit
      8: pw.FixedColumnWidth(54), // Credit
      9: pw.FixedColumnWidth(64), // Balance
    };

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        header: (context) {
          if (context.pageNumber > 1) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'LEDGER - ${partyName.toUpperCase()}',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        'Page ${context.pageNumber} of ${context.pagesCount}',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Table(
                  border: pw.TableBorder(
                    top: const pw.BorderSide(color: PdfColors.black, width: 0.8),
                    bottom: const pw.BorderSide(color: PdfColors.black, width: 0.8),
                  ),
                  columnWidths: detailedColumnWidths,
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.white),
                      children: [
                        _cellSmall('Date', isBold: true, align: pw.TextAlign.center),
                        _cellSmall('Vch. No.', isBold: true, align: pw.TextAlign.center),
                        _cellSmall('Ref', isBold: true, align: pw.TextAlign.center),
                        _cellSmall('Description', isBold: true, align: pw.TextAlign.left),
                        _cellSmall('QTY', isBold: true, align: pw.TextAlign.right),
                        _cellSmall('Weight', isBold: true, align: pw.TextAlign.right),
                        _cellSmall('Rate', isBold: true, align: pw.TextAlign.right),
                        _cellSmall('Debit', isBold: true, align: pw.TextAlign.right, color: _debitColor),
                        _cellSmall('Credit', isBold: true, align: pw.TextAlign.right, color: _creditColor),
                        _cellSmall('Balance', isBold: true, align: pw.TextAlign.right),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
          return pw.SizedBox();
        },
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildPage1Header(
            companyName: companyName,
            companyCity: companyCity,
            partyName: partyName,
            address: address,
            contact: contact,
            email: email,
            city: city,
            web: web,
            partyId: partyId,
            fromDate: fromDate,
            toDate: toDate,
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder(
              top: const pw.BorderSide(color: PdfColors.black, width: 0.8),
              bottom: const pw.BorderSide(color: PdfColors.black, width: 0.8),
              horizontalInside: const pw.BorderSide(
                color: PdfColors.grey300,
                width: 0.4,
              ),
            ),
            columnWidths: detailedColumnWidths,
            children: tableRows,
          ),
          pw.SizedBox(height: 12),
          _buildBottomSummaryCards(
            totalDebit: totalDebit,
            totalCredit: totalCredit,
            runningBalance: runningBalance,
            partyType: partyType,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STANDARD STYLE (Statement grid, 6 columns)
  // ==========================================
  static void _buildStandardPdf({
    required pw.Document doc,
    required int partyId,
    required String partyName,
    required PartyType partyType,
    String? address,
    String? contact,
    String? email,
    String? city,
    String? web,
    required String companyName,
    required String companyCity,
    required DateTime fromDate,
    required DateTime toDate,
    required double previousBalance,
    required List<LedgerEntity> periodEntries,
    required Map<String, ProcurementEntity> procMap,
    required Map<String, DisbursementRecord> disbMap,
    required Map<String, InvoiceEntity> invMap,
    required Map<String, ReceiptEntity> recMap,
    Map<int, String>? rawMaterialsMap,
    Map<int, String>? productsMap,
  }) {
    double runningBalance = previousBalance;
    double totalDebit = 0;
    double totalCredit = 0;

    final tableRows = <pw.TableRow>[];

    // Table Header Row
    tableRows.add(
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.white),
        children: [
          _headerCell('Voucher #', align: pw.TextAlign.center),
          _headerCell('Date', align: pw.TextAlign.center),
          _headerCell('Narration', align: pw.TextAlign.center),
          _headerCell('Debit', align: pw.TextAlign.center, color: _debitColor),
          _headerCell('Credit', align: pw.TextAlign.center, color: _creditColor),
          _headerCell('Balance', align: pw.TextAlign.center),
        ],
      ),
    );

    // Previous Balance Row (Row 1)
    final prevBalStr = _formatBalance(previousBalance, partyType);
    final prevBalColor = prevBalStr.contains('Cr.')
        ? _creditColor
        : (prevBalStr.contains('Dr.') ? _debitColor : PdfColors.black);

    tableRows.add(
      pw.TableRow(
        children: [
          _cell(''),
          _cell(''),
          _cell('Previous Balance', isBold: true),
          _cell(''),
          _cell(''),
          _cell(
            prevBalStr,
            isBold: true,
            align: pw.TextAlign.right,
            color: prevBalColor,
          ),
        ],
      ),
    );

    for (final entry in periodEntries) {
      final isDebit = entry.entryType == EntryType.debit;
      final source = (entry.transactionSource ?? '').toLowerCase();
      final refId = entry.referenceId ?? '';
      final invNo = entry.invoiceNumber ?? '';
      final formattedDate = DateFormat('dd/MM/yyyy').format(entry.entryDate);

      String vchNo = '';
      String narration = '';
      double itemDebit = 0;
      double itemCredit = 0;

      if (partyType == PartyType.vendor) {
        ProcurementEntity? matchingProc;
        if (source == 'procurement' || invNo.startsWith('PRC-')) {
          matchingProc =
              procMap[refId] ??
              procMap[invNo] ??
              procMap[invNo.replaceAll('PRC-', '')];
        }

        DisbursementRecord? matchingDisb;
        if (source == 'disbursement' || invNo.startsWith('DSB-')) {
          matchingDisb = disbMap[refId] ?? disbMap[invNo];
        }

        if (matchingProc != null) {
          vchNo = matchingProc.id != null ? 'PRC-${matchingProc.id}' : invNo;
          final refVal = matchingProc.notes?.trim() ?? '';
          narration = 'PURCHASE INVOICE NO.$vchNo';
          if (refVal.isNotEmpty) narration += ' &\nREF NO.$refVal';

          final entryRem = entry.remarks?.trim() ?? '';
          if (entryRem.isNotEmpty &&
              !entryRem.toLowerCase().startsWith('auto credit')) {
            narration += '\n$entryRem';
          } else if (matchingProc.items.isNotEmpty) {
            final matNames = matchingProc.items
                .map(
                  (i) => rawMaterialsMap?[i.rawMaterialId] ?? '',
                )
                .where((n) => n.isNotEmpty)
                .join(', ');
            if (matNames.isNotEmpty) {
              narration += '\n$matNames';
            }
          }

          itemDebit = isDebit ? entry.amount : 0.0;
          itemCredit = isDebit ? 0.0 : entry.amount;
        } else if (matchingDisb != null) {
          final accRef = matchingDisb.accountNo?.trim();
          vchNo = (accRef != null && accRef.isNotEmpty)
              ? accRef
              : matchingDisb.disbursementNumber;

          final disbRem = matchingDisb.remarks?.trim() ?? '';
          final entryRem = entry.remarks?.trim() ?? '';
          if (disbRem.isNotEmpty) {
            narration = disbRem;
          } else if (entryRem.isNotEmpty) {
            narration = entryRem;
          } else {
            narration = '${matchingDisb.paymentMethod} Payment';
          }

          itemDebit = entry.amount;
          itemCredit = 0.0;
        } else {
          vchNo = invNo.isNotEmpty ? invNo : refId;
          final entryRem = entry.remarks?.trim() ?? '';
          if (entryRem.isNotEmpty) {
            narration = entryRem;
          } else {
            narration = entry.paymentMethod?.isNotEmpty == true
                ? '${entry.paymentMethod} Payment'
                : (isDebit ? 'Debit Entry' : 'Credit Entry');
          }

          itemDebit = isDebit ? entry.amount : 0.0;
          itemCredit = isDebit ? 0.0 : entry.amount;
        }

        totalDebit += itemDebit;
        totalCredit += itemCredit;
        runningBalance += (itemCredit - itemDebit);
      } else {
        InvoiceEntity? matchingInv;
        if (source == 'invoice' || invNo.startsWith('INV-')) {
          matchingInv = invMap[refId] ?? invMap[invNo];
        }

        ReceiptEntity? matchingRec;
        if (source.contains('receipt') ||
            invNo.startsWith('REC-') ||
            invNo.startsWith('RCPT-')) {
          matchingRec =
              recMap[refId] ??
              recMap[invNo] ??
              recMap[invNo.replaceAll('RCPT-', '')] ??
              recMap[invNo.replaceAll('REC-', '')];
        }

        final isFare =
            refId.startsWith('invoice_fare:') ||
            (entry.remarks?.toLowerCase().contains('fare') ?? false);

        if (isFare) {
          vchNo = matchingInv?.invoiceNumber ?? invNo;
          final refVal = matchingInv?.po ?? '';
          narration = 'Fare (Ex factory)';
          if (refVal.isNotEmpty) narration += ' [Ref: $refVal]';
          if (entry.remarks?.isNotEmpty == true) {
            narration += '\n${entry.remarks}';
          }

          itemDebit = isDebit ? entry.amount : 0.0;
          itemCredit = isDebit ? 0.0 : entry.amount;
        } else if (matchingInv != null) {
          vchNo = matchingInv.invoiceNumber;
          final refVal = matchingInv.po?.trim() ?? '';
          narration = 'SALES INVOICE NO.$vchNo';
          if (refVal.isNotEmpty) narration += ' &\nREF NO.$refVal';

          final entryRem = entry.remarks?.trim() ?? '';
          if (entryRem.isNotEmpty) {
            narration += '\n$entryRem';
          } else if (matchingInv.items.isNotEmpty) {
            final itemDescs = matchingInv.items
                .map(
                  (it) =>
                      it.description ?? productsMap?[it.productId] ?? '',
                )
                .where((d) => d.isNotEmpty)
                .join(', ');
            if (itemDescs.isNotEmpty) {
              narration += '\n$itemDescs';
            }
          }

          itemDebit = isDebit ? entry.amount : 0.0;
          itemCredit = isDebit ? 0.0 : entry.amount;
        } else if (matchingRec != null) {
          final accRef = matchingRec.accountNo?.trim();
          vchNo = (accRef != null && accRef.isNotEmpty)
              ? accRef
              : (matchingRec.receiptNumber ?? invNo);

          final recRem = matchingRec.remarks?.trim() ?? '';
          final entryRem = entry.remarks?.trim() ?? '';
          if (recRem.isNotEmpty) {
            narration = recRem;
          } else if (entryRem.isNotEmpty) {
            narration = entryRem;
          } else {
            final rawMethod = matchingRec.paymentMethod.trim().toLowerCase();
            narration = switch (rawMethod) {
              'bank' => 'Bank Payment',
              'cash' => 'Cash Payment',
              'cheque' => 'Cheque Payment',
              _ =>
                rawMethod.isNotEmpty
                    ? '${rawMethod[0].toUpperCase()}${rawMethod.substring(1)} Payment'
                    : 'Bank Payment',
            };
          }

          itemDebit = 0.0;
          itemCredit = entry.amount;
        } else {
          vchNo = invNo.isNotEmpty ? invNo : refId;
          final entryRem = entry.remarks?.trim() ?? '';
          if (entryRem.isNotEmpty) {
            narration = entryRem;
          } else {
            narration = entry.paymentMethod?.isNotEmpty == true
                ? '${entry.paymentMethod} Payment'
                : (isDebit ? 'Debit Entry' : 'Bank Payment');
          }

          itemDebit = isDebit ? entry.amount : 0.0;
          itemCredit = isDebit ? 0.0 : entry.amount;
        }

        totalDebit += itemDebit;
        totalCredit += itemCredit;
        runningBalance += (itemDebit - itemCredit);
      }

      final debitStr = itemDebit > 0 ? _formatAmount(itemDebit) : '0';
      final creditStr = itemCredit > 0 ? _formatAmount(itemCredit) : '0';
      final balanceStr = _formatBalance(runningBalance, partyType);

      final debitColor = itemDebit > 0 ? _debitColor : _zeroColor;
      final creditColor = itemCredit > 0 ? _creditColor : _zeroColor;
      final balanceColor = balanceStr.contains('Cr.')
          ? _creditColor
          : (balanceStr.contains('Dr.') ? _debitColor : PdfColors.black);

      tableRows.add(
        pw.TableRow(
          children: [
            _cell(vchNo, align: pw.TextAlign.center),
            _cell(formattedDate, align: pw.TextAlign.center),
            _cell(narration, align: pw.TextAlign.left),
            _cell(
              debitStr,
              align: pw.TextAlign.right,
              color: debitColor,
              isBold: itemDebit > 0,
            ),
            _cell(
              creditStr,
              align: pw.TextAlign.right,
              color: creditColor,
              isBold: itemCredit > 0,
            ),
            _cell(
              balanceStr,
              align: pw.TextAlign.right,
              color: balanceColor,
              isBold: true,
            ),
          ],
        ),
      );
    }

    // Grand Total Row
    final totalBalStr = _formatBalance(runningBalance, partyType);
    final totalBalColor = totalBalStr.contains('Cr.')
        ? _creditColor
        : (totalBalStr.contains('Dr.') ? _debitColor : PdfColors.black);

    tableRows.add(
      pw.TableRow(
        children: [
          _cell(''),
          _cell(''),
          _cell('Total', isBold: true),
          _cell(
            _formatAmount(totalDebit),
            isBold: true,
            align: pw.TextAlign.right,
            color: totalDebit > 0 ? _debitColor : PdfColors.black,
          ),
          _cell(
            _formatAmount(totalCredit),
            isBold: true,
            align: pw.TextAlign.right,
            color: totalCredit > 0 ? _creditColor : PdfColors.black,
          ),
          _cell(
            totalBalStr,
            isBold: true,
            align: pw.TextAlign.right,
            color: totalBalColor,
          ),
        ],
      ),
    );

    const columnWidths = {
      0: pw.FixedColumnWidth(68), // Voucher #
      1: pw.FixedColumnWidth(58), // Date
      2: pw.FlexColumnWidth(3.0), // Narration
      3: pw.FixedColumnWidth(72), // Debit
      4: pw.FixedColumnWidth(72), // Credit
      5: pw.FixedColumnWidth(80), // Balance
    };

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        header: (context) {
          if (context.pageNumber > 1) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'LEDGER - ${partyName.toUpperCase()}',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        'Page ${context.pageNumber} of ${context.pagesCount}',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    width: 0.8,
                  ),
                  columnWidths: columnWidths,
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.white,
                      ),
                      children: [
                        _headerCell('Voucher #', align: pw.TextAlign.center),
                        _headerCell('Date', align: pw.TextAlign.center),
                        _headerCell('Narration', align: pw.TextAlign.center),
                        _headerCell('Debit', align: pw.TextAlign.center, color: _debitColor),
                        _headerCell('Credit', align: pw.TextAlign.center, color: _creditColor),
                        _headerCell('Balance', align: pw.TextAlign.center),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
          return pw.SizedBox();
        },
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildPage1Header(
            companyName: companyName,
            companyCity: companyCity,
            partyName: partyName,
            address: address,
            contact: contact,
            email: email,
            city: city,
            web: web,
            partyId: partyId,
            fromDate: fromDate,
            toDate: toDate,
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.8),
            columnWidths: columnWidths,
            children: tableRows,
          ),
          pw.SizedBox(height: 12),
          _buildBottomSummaryCards(
            totalDebit: totalDebit,
            totalCredit: totalCredit,
            runningBalance: runningBalance,
            partyType: partyType,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SHARED HEADER & FOOTER & SUMMARY WIDGETS
  // ==========================================
  static pw.Widget _buildPage1Header({
    required String companyName,
    required String companyCity,
    required String partyName,
    String? address,
    String? contact,
    String? email,
    String? city,
    String? web,
    int? partyId,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    final partyCode = partyId != null
        ? '02-01-${partyId.toString().padLeft(3, '0')}'
        : '';
    final resolvedCity = city?.isNotEmpty == true
        ? city!
        : (address?.toUpperCase().contains('LAHORE') == true
            ? 'LAHORE'
            : 'GUJRANWALA');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Top Row: LEDGER in Blue on left, Company Name in Red on right
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'LEDGER',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#0088EA'),
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  companyName,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#E5252A'),
                  ),
                ),
                if (companyCity.isNotEmpty) ...[
                  pw.SizedBox(height: 1),
                  pw.Text(
                    companyCity,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 12),

        // Middle Row: Account Box on left, Dates on right
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // Account Box
            pw.Container(
              width: 320,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 1.0),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildBoxRow(
                    'Account:',
                    partyName.toUpperCase(),
                    isBold: true,
                  ),
                  pw.SizedBox(height: 2),
                  _buildBoxRow('Address:', (address ?? '').toUpperCase()),
                  pw.SizedBox(height: 2),
                  _buildCityRow(
                    'City:',
                    resolvedCity.toUpperCase(),
                    partyCode,
                  ),
                  pw.SizedBox(height: 2),
                  _buildBoxRow('Contact:', contact ?? ''),
                  pw.SizedBox(height: 2),
                  _buildBoxRow('Email:', (email ?? '').toUpperCase()),
                  pw.SizedBox(height: 2),
                  _buildBoxRow('Web:', (web ?? '').toUpperCase()),
                ],
              ),
            ),

            // Date Range
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      'From Date',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(width: 28),
                    pw.Text(
                      DateFormat('dd/MM/yyyy').format(fromDate),
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      'To Date',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(width: 40),
                    pw.Text(
                      DateFormat('dd/MM/yyyy').format(toDate),
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildBottomSummaryCards({
    required double totalDebit,
    required double totalCredit,
    required double runningBalance,
    required PartyType partyType,
  }) {
    final balStr = _formatBalance(runningBalance, partyType);
    final balColor = balStr.contains('Cr.')
        ? _creditColor
        : (balStr.contains('Dr.') ? _debitColor : PdfColors.black);

    final String balanceNote;
    if (partyType == PartyType.vendor) {
      if (balStr.contains('Cr.')) {
        balanceNote = 'This is how much you owe this vendor.';
      } else if (balStr.contains('Dr.')) {
        balanceNote = 'Advance paid to vendor.';
      } else {
        balanceNote = 'Account is completely settled.';
      }
    } else {
      if (balStr.contains('Dr.')) {
        balanceNote = 'This is how much this client owes you.';
      } else if (balStr.contains('Cr.')) {
        balanceNote = 'Advance received from client.';
      } else {
        balanceNote = 'Account is completely settled.';
      }
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F8FAFC'),
        border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0'), width: 0.8),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Total Debit
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Total Debit',
                style: const pw.TextStyle(
                  fontSize: 8.5,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                _formatAmount(totalDebit),
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: totalDebit > 0 ? _debitColor : PdfColors.black,
                ),
              ),
            ],
          ),
          pw.Container(width: 0.8, height: 30, color: PdfColor.fromHex('#CBD5E1')),

          // Total Credit
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Total Credit',
                style: const pw.TextStyle(
                  fontSize: 8.5,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                _formatAmount(totalCredit),
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: totalCredit > 0 ? _creditColor : PdfColors.black,
                ),
              ),
            ],
          ),
          pw.Container(width: 0.8, height: 30, color: PdfColor.fromHex('#CBD5E1')),

          // Net Balance
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Balance',
                style: const pw.TextStyle(
                  fontSize: 8.5,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                balStr,
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: balColor,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                balanceNote,
                style: const pw.TextStyle(
                  fontSize: 7,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Printed on: ${DateFormat('dd/MM/yyyy h:mm a').format(DateTime.now())}',
            style: const pw.TextStyle(
              fontSize: 7.5,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(
              fontSize: 7.5,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBoxRow(
    String label,
    String value, {
    bool isBold = false,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 50,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: PdfColors.black,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildCityRow(String label, String city, String code) {
    return pw.Row(
      children: [
        pw.SizedBox(
          width: 50,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            city,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
          ),
        ),
        if (code.isNotEmpty)
          pw.Text(
            code,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
          ),
      ],
    );
  }

  static pw.Widget _headerCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor color = PdfColors.black,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: pw.FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  static pw.Widget _cell(
    String text, {
    bool isBold = false,
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor color = PdfColors.black,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  static pw.Widget _cellSmall(
    String text, {
    bool isBold = false,
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor color = PdfColors.black,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 2.5, vertical: 3.5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 7,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}
