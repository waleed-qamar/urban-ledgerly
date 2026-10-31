import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import '../../client/domain/entities/client_entity.dart';
import '../../products/domain/entities/product_entity.dart';
import '../../products/domain/entities/product_set_entity.dart';
import '../../orders/domain/entities/supplier_entity.dart';
import '../domain/entities/invoice_entity.dart';

class PdfGenerator {
  // Different letterhead assets (one per supplier/style) have very different
  // banner heights and layouts — e.g. Encore's is a slim green band, while
  // Urban Constructions' is a tall dark banner with a baked-in product
  // title. A single global top margin can't safely fit both.
  //
  // On top of that, a sales-tax invoice renders a TALLER title block than a
  // commercial invoice (two stacked lines — "SALES TAX INVOICE" then
  // "COMMERCIAL INVOICE" — vs just one), so it needs extra top clearance
  // even on the same letterhead.
  //
  // To add a new letterhead: measure clearance needed for both invoice
  // types against that PNG and add an entry below keyed by the asset name
  // (same string used for 'assets/$assetName.png'). Unlisted assets fall
  // back to _defaultMargins.
  static const Map<String, _LetterheadMargins> _letterheadMargins = {
    'encore_enterprises': _LetterheadMargins(
      topCommercial: 130,
      topSalesTax: 150,
      bottom: 170,
      sides: 36,
    ),
    'urban_constructions': _LetterheadMargins(
      // Tall dark header banner + embedded product title graphic needs
      // significantly more top clearance than Encore's. Increase further
      // if the title block still touches the banner on real invoices —
      // this is a starting estimate based on the reported overlap.
      topCommercial: 190,
      topSalesTax: 215,
      bottom: 170,
      sides: 36,
    ),
  };

  static const _LetterheadMargins _defaultMargins = _LetterheadMargins(
    topCommercial: 130,
    topSalesTax: 150,
    bottom: 170,
    sides: 36,
  );

  static Future<void> generateAndPrintInvoice({
    required InvoiceEntity invoice,
    required Map<int, ProductEntity> products,
    required Map<int, ProductSetEntity> sets,
    ClientEntity? client,
    SupplierEntity? supplier,
  }) async {
    final doc = pw.Document();

    // Determine initials and filenames
    final String assetName = invoice.supplierStyle.trim().isNotEmpty
        ? invoice.supplierStyle.trim()
        : 'encore_enterprises';

    pw.MemoryImage? backgroundLetterhead;
    try {
      final ByteData imageData = await rootBundle.load('assets/$assetName.png');
      backgroundLetterhead = pw.MemoryImage(imageData.buffer.asUint8List());
    } catch (e) {
      print(
        "Warning: Background template image assets/$assetName.png not found: $e",
      );
    }

    final isSalesTax = invoice.invoiceType == 'sales_tax';

    final margins = _letterheadMargins[assetName] ?? _defaultMargins;
    final effectiveTopMargin = isSalesTax
        ? margins.topSalesTax
        : margins.topCommercial;

    final supplierName =
        invoice.supplierName ?? supplier?.name ?? 'Unknown Supplier';
    final supplierAddr = invoice.supplierAddress ?? supplier?.address ?? '';
    final supplierStrnVal = invoice.supplierStrn ?? supplier?.strnNo ?? '';
    final supplierNtnVal = invoice.supplierNtn ?? supplier?.ntn ?? '';

    final clientNameVal =
        invoice.clientName ?? client?.clientName ?? 'Unknown Client';
    final clientAddrVal = invoice.clientAddress ?? client?.clientAddress ?? '';
    final clientStrnVal = invoice.clientStrn ?? '';
    final clientNtnVal = invoice.clientNtn ?? '';

    final dateStr =
        '${invoice.issueDate.day.toString().padLeft(2, '0')}-${invoice.issueDate.month.toString().padLeft(2, '0')}-${invoice.issueDate.year}';

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          // Asymmetric safe-zone margins instead of a flat 32 on all sides.
          // This is what keeps the table/text off the letterhead's header
          // and footer artwork regardless of how much content there is.
          // Because this lives on pageTheme (not on a single Page), it is
          // reapplied on every page pw.MultiPage generates, so a 2nd/3rd
          // page gets the same safe zone and the same repeated background.
          margin: pw.EdgeInsets.only(
            top: effectiveTopMargin,
            bottom: margins.bottom,
            left: margins.sides,
            right: margins.sides,
          ),
          buildBackground: backgroundLetterhead == null
              ? null
              : (pw.Context ctx) => pw.FullPage(
                  ignoreMargins: true,
                  child: pw.Image(backgroundLetterhead!, fit: pw.BoxFit.fill),
                ),
        ),
        // pw.MultiPage measures each widget in this list and, once a page's
        // safe zone is full, automatically starts a new page (repeating
        // pageTheme — including the letterhead background — on it). This
        // replaces the old single pw.Page, which would silently clip any
        // content that didn't fit rather than continuing onto a new page.
        //
        // Note: pw.Table (used below) does not repeat its header row on a
        // page break by default. If invoices commonly run long enough to
        // split mid-table, consider swapping it for pw.TableHelper.fromTextArray
        // with a `headers:` argument, which repeats the header row on every
        // page automatically.
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (context) {
          return [
            // Document Title — one title only, matching invoice.invoiceType
            pw.Center(
              child: pw.Text(
                isSalesTax ? 'SALES TAX INVOICE' : 'COMMERCIAL INVOICE',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            // Invoice No & Date
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Invoice No. ${invoice.invoiceNumber}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.Text(
                  'Dates: $dateStr',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),

            // Supplier & Buyer Info boxes
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Supplier Box
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 1),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Supplier Name', supplierName),
                        pw.Divider(color: PdfColors.black, thickness: 0.5),

                        _buildInfoRow('Supplier Address', supplierAddr),

                        if (isSalesTax &&
                            supplierStrnVal != null &&
                            supplierStrnVal.toString().trim().isNotEmpty) ...[
                          pw.Divider(color: PdfColors.black, thickness: 0.5),
                          _buildInfoRow('STRN No.', supplierStrnVal),
                        ],

                        if (isSalesTax &&
                            supplierNtnVal != null &&
                            supplierNtnVal.toString().trim().isNotEmpty) ...[
                          pw.Divider(color: PdfColors.black, thickness: 0.5),
                          _buildInfoRow('NTN No.', supplierNtnVal),
                        ],
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 16),
                // Buyer Box
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 1),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Buyer Name', clientNameVal),
                        pw.Divider(color: PdfColors.black, thickness: 0.5),

                        _buildInfoRow('Buyer Address', clientAddrVal),

                        if (isSalesTax &&
                            clientStrnVal != null &&
                            clientStrnVal.toString().trim().isNotEmpty) ...[
                          pw.Divider(color: PdfColors.black, thickness: 0.5),
                          _buildInfoRow('SSTRN No.', clientStrnVal),
                        ],

                        if (isSalesTax &&
                            clientNtnVal != null &&
                            clientNtnVal.toString().trim().isNotEmpty) ...[
                          pw.Divider(color: PdfColors.black, thickness: 0.5),
                          _buildInfoRow('NTN No.', clientNtnVal),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 1),
              columnWidths: {
                0: const pw.FixedColumnWidth(40),
                1: const pw.FlexColumnWidth(6),
                2: const pw.FixedColumnWidth(50),
                3: const pw.FixedColumnWidth(50),
                4: const pw.FixedColumnWidth(100),
                5: const pw.FixedColumnWidth(100),
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    _buildHeaderCell('Sr.No.', align: pw.TextAlign.center),
                    _buildHeaderCell('Description'),
                    _buildHeaderCell('Qty', align: pw.TextAlign.center),
                    _buildHeaderCell('Units', align: pw.TextAlign.center),
                    _buildHeaderCell(
                      'Unit Price (Rs)',
                      align: pw.TextAlign.right,
                    ),
                    _buildHeaderCell('Amount', align: pw.TextAlign.right),
                  ],
                ),
                // Table Rows
                ...List.generate(invoice.items.length, (index) {
                  final item = invoice.items[index];
                  final description = item.description ?? '';
                  final qty = item.quantity;
                  final unitType = item.unitType;
                  final unitPrice = item.unitPrice;
                  final amount = item.totalPrice;

                  return pw.TableRow(
                    children: [
                      _buildCell('${index + 1}', align: pw.TextAlign.center),
                      _buildCell(description),
                      _buildCell('$qty', align: pw.TextAlign.center),
                      _buildCell(unitType, align: pw.TextAlign.center),
                      _buildCell(
                        unitPrice.toStringAsFixed(2),
                        align: pw.TextAlign.right,
                      ),
                      _buildCell(
                        amount.toStringAsFixed(2),
                        align: pw.TextAlign.right,
                      ),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 20),

            // Totals and Advance/Balance
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  width: 280,
                  child: pw.Column(
                    children: [
                      _buildTotalRow('Sub Total', invoice.subTotal),
                      if (isSalesTax)
                        _buildTotalRow(
                          'GST (${invoice.taxPercent.toStringAsFixed(0)}%)',
                          invoice.taxAmount,
                        ),
                      if (invoice.advanceAmount > 0)
                        _buildTotalRow(
                          isSalesTax ? 'Advance (without GST)' : 'Advance',
                          invoice.advanceAmount,
                        ),
                      pw.Divider(color: PdfColors.black, thickness: 1),
                      _buildTotalRow(
                        'Balance',
                        invoice.grandTotal - invoice.advanceAmount,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Prepared By / Authorized Signature block removed — it was
            // the piece landing on top of the "Sales Dept." /
            // address-CEO-logo area on the letterhead. "Sales Dept." and
            // the signature line now come entirely from the letterhead
            // artwork itself, sitting below this content with the
            // generous bottom safe margin defined above.
          ];
        },
      ),
    );

    final bytes = await doc.save();
    await FileSaver.instance.saveFile(
      name: invoice.invoiceNumber,
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 90,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHeaderCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
        textAlign: align,
      ),
    );
  }

  static pw.Widget _buildCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9),
        textAlign: align,
      ),
    );
  }

  static pw.Widget _buildTotalRow(
    String label,
    double value, {
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 10,
            ),
          ),
          pw.Text(
            '${value.toStringAsFixed(2)}/-',
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// Safe-zone margins for one letterhead asset, split by invoice type
/// because sales-tax invoices render a taller title block than commercial
/// invoices and need more top clearance on the same background artwork.
class _LetterheadMargins {
  final double topCommercial;
  final double topSalesTax;
  final double bottom;
  final double sides;

  const _LetterheadMargins({
    required this.topCommercial,
    required this.topSalesTax,
    required this.bottom,
    required this.sides,
  });
}
