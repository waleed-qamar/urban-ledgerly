import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';
import '../../client/domain/entities/client_entity.dart';
import '../../products/domain/entities/product_entity.dart';
import '../../orders/domain/entities/supplier_entity.dart';
import '../domain/entities/invoice_entity.dart';

class PdfGenerator {
  static Future<void> generateAndPrintInvoice({
    required InvoiceEntity invoice,
    required Map<int, ProductEntity> products,
    required ClientEntity client,
    required SupplierEntity supplier,
  }) async {
    final doc = pw.Document();
    final representativeName = invoice.representative.trim().isEmpty
        ? 'N/A'
        : invoice.representative.trim();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'INVOICE',
                    style: pw.TextStyle(
                      fontSize: 40,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Invoice #: ${invoice.invoiceNumber}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Date: ${invoice.issueDate.toLocal().toString().split(' ')[0]}',
                      ),
                      pw.Text('PO: ${invoice.po ?? 'N/A'}'),
                      pw.Text('Representative: $representativeName'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),

              // Addresses
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'From:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(supplier.name),
                        pw.Text(supplier.address),
                        pw.Text('Phone: ${supplier.contactInfo ?? "N/A"}'),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Bill To:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(client.clientName),
                        pw.Text(client.clientAddress),
                        pw.Text('Phone: ${client.contactNumber}'),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 40),

              // Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Item Description',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Qty',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Unit Price',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  ...invoice.items.map((item) {
                    final pName =
                        products[item.productId]?.name ??
                        'Item #${item.productId}';
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(pName),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            '${item.quantity}',
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            item.unitPrice.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            item.totalPrice.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 20),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 250,
                    child: pw.Column(
                      children: [
                        _buildTotalRow('Subtotal:', invoice.subTotal),
                        _buildTotalRow('Shipping Cost:', invoice.shippingCost),
                        _buildTotalRow(
                          'GST (${invoice.taxPercent}%):',
                          invoice.taxAmount,
                        ),
                        pw.Divider(),
                        _buildTotalRow(
                          'Grand Total:',
                          invoice.grandTotal,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
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
            ),
          ),
          pw.Text(
            'PKR ${value.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
