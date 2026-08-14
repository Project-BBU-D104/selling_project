import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/models/report/report_detail_model.dart';
import 'package:selling_project/models/report/report_model.dart';

class PdfServices {
  static Future<void> generateAndExportPdf({
    required String filterTitle,
    required ReportSummaryModel? summary,
    required List<SalesTransactionModel> transactions,
  }) async {
    final pdf = pw.Document();
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "SALES REPORT",
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text("Filter Period: $filterTitle"),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Date Generated:"),
                    pw.Text(DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text("Summary", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem("Total Revenue", currencyFormat.format(summary?.totalSales ?? 0)),
                  _buildSummaryItem("Net Profit", currencyFormat.format(summary?.netProfit ?? 0)),
                  _buildSummaryItem("Total Orders", "${summary?.totalOrders ?? 0}"),
                  _buildSummaryItem("Items Sold", "${summary?.totalProductsSold ?? 0}"),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Transactions History", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: ['Invoice #', 'Date', 'Qty', 'Profit', 'Total Amount'],
              data: transactions.map((item) {
                return [
                  "#${item.invoiceNo}",
                  dateFormat.format(item.date),
                  "${item.totalQty}",
                  currencyFormat.format(item.profit),
                  currencyFormat.format(item.grandTotal),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(6),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Sales_Report_${filterTitle.replaceAll(" ", "_")}.pdf',
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
}