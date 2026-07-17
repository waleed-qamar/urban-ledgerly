import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

import '../../employee/domain/entities/operator_entity.dart';
import '../domain/entities/attendance_day_row.dart';
import '../presentation/providers/attendance_review_providers.dart';

class AttendanceExportService {
  static final _dateFormat = DateFormat('dd MMM yyyy');

  /// Generate Excel file bytes
  static List<int>? exportToExcel({
    required List<OperatorEntity> operators,
    required Map<int, List<AttendanceDayRow>> operatorRowsMap,
    required Map<int, List<CalculatedPay>> operatorCalculatedPaysMap,
  }) {
    final excel = Excel.createExcel();
    final sheetName = 'Attendance Report';
    excel.rename('Sheet1', sheetName);
    final sheet = excel[sheetName];

    for (final op in operators) {
      final rows = operatorRowsMap[op.id] ?? [];
      final calculatedPays = operatorCalculatedPaysMap[op.id] ?? [];

      if (rows.isEmpty) continue;

      // Add a blank row if it's not the first row
      if (sheet.maxRows > 0) {
        sheet.appendRow([TextCellValue('')]);
        sheet.appendRow([TextCellValue('')]);
      }

      // Operator Heading
      sheet.appendRow([TextCellValue('Operator: ${op.name}')]);
      // Header Row
      sheet.appendRow([
        TextCellValue('Date'),
        TextCellValue('Shift Role'),
        TextCellValue('Shift Hrs'),
        TextCellValue('OT Role'),
        TextCellValue('OT Hrs'),
        TextCellValue('Reason'),
        TextCellValue('Wage Pay (PKR)'),
        TextCellValue('OT Pay (PKR)'),
        TextCellValue('Take Home (PKR)'),
      ]);

      // Data Rows
      double totalWage = 0;
      double totalOt = 0;
      double totalTakeHome = 0;

      for (int i = 0; i < rows.length; i++) {
        final r = rows[i];
        final pay = calculatedPays[i];

        totalWage += pay.wagePay;
        totalOt += pay.otPay;
        totalTakeHome += pay.takeHome;

        sheet.appendRow([
          TextCellValue(_dateFormat.format(r.date)),
          TextCellValue(r.shiftRoleName),
          TextCellValue(_formatDuration(pay.normalHrs)),
          TextCellValue(r.otRoleName ?? '-'),
          TextCellValue(_formatDuration(pay.otHrs)),
          TextCellValue(r.existingAdjustmentReason ?? ''),
          DoubleCellValue(pay.wagePay),
          DoubleCellValue(pay.otPay),
          DoubleCellValue(pay.takeHome),
        ]);
      }

      // Summary Row
      sheet.appendRow([
        TextCellValue('TOTAL'),
        TextCellValue(''),
        TextCellValue(''),
        TextCellValue(''),
        TextCellValue(''),
        TextCellValue(''),
        DoubleCellValue(totalWage),
        DoubleCellValue(totalOt),
        DoubleCellValue(totalTakeHome),
      ]);
    }

    return excel.save();
  }

  /// Generate PDF file bytes
  static Future<Uint8List> exportToPdf({
    required List<OperatorEntity> operators,
    required Map<int, List<AttendanceDayRow>> operatorRowsMap,
    required Map<int, List<CalculatedPay>> operatorCalculatedPaysMap,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          final List<pw.Widget> widgets = [];

          // Document Header
          widgets.add(
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Attendance Review Report',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Period: ${_dateFormat.format(fromDate)} to ${_dateFormat.format(toDate)}',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 24),
              ],
            ),
          );

          for (final op in operators) {
            final rows = operatorRowsMap[op.id] ?? [];
            final calculatedPays = operatorCalculatedPaysMap[op.id] ?? [];

            if (rows.isEmpty) continue;

            double totalWage = 0;
            double totalOt = 0;
            double totalTakeHome = 0;

            final tableHeaders = [
              'Date',
              'Shift Role',
              'Shift Hrs',
              'OT Role',
              'OT Hrs',
              'Reason',
              'Wage Pay',
              'OT Pay',
              'Take Home',
            ];

            final tableData = <List<String>>[];

            for (int i = 0; i < rows.length; i++) {
              final r = rows[i];
              final pay = calculatedPays[i];

              totalWage += pay.wagePay;
              totalOt += pay.otPay;
              totalTakeHome += pay.takeHome;

              tableData.add([
                _dateFormat.format(r.date),
                r.shiftRoleName,
                _formatDuration(pay.normalHrs),
                r.otRoleName ?? '-',
                _formatDuration(pay.otHrs),
                r.existingAdjustmentReason ?? '',
                pay.wagePay.toStringAsFixed(2),
                pay.otPay.toStringAsFixed(2),
                pay.takeHome.toStringAsFixed(2),
              ]);
            }

            tableData.add([
              'TOTAL',
              '',
              '',
              '',
              '',
              '',
              totalWage.toStringAsFixed(2),
              totalOt.toStringAsFixed(2),
              totalTakeHome.toStringAsFixed(2),
            ]);

            widgets.add(
              pw.Text(
                'Operator: ${op.name}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            );
            widgets.add(pw.SizedBox(height: 8));
            widgets.add(
              pw.TableHelper.fromTextArray(
                headers: tableHeaders,
                data: tableData,
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blueGrey800,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerLeft,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.centerLeft,
                  6: pw.Alignment.centerRight,
                  7: pw.Alignment.centerRight,
                  8: pw.Alignment.centerRight,
                },
              ),
            );
            widgets.add(pw.SizedBox(height: 24));
          }

          return widgets;
        },
      ),
    );

    return pdf.save();
  }

  static String _formatDuration(double hours) {
    final int h = hours.floor();
    final int m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }
}
