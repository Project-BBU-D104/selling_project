import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:selling_project/models/sale/sale_model.dart';
import 'package:selling_project/services/telegram_services.dart';

class PrintHelper {
  static void showPrintOptionsModal(BuildContext context, SaleModel saleData) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Receipt & Export Options",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.print, color: Color(0xFF3B1EFA)),
                title: const Text("Print / Preview PDF"),
                onTap: () {
                  Navigator.pop(context);
                  generateAndPrintPdf(saleData);
                },
              ),
              ListTile(
                leading: const Icon(Icons.send, color: Colors.blue),
                title: const Text("Send to Telegram"),
                onTap: () {
                  Navigator.pop(context);
                  shareToTelegram(saleData);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.orange),
                title: const Text("Copy Invoice Text"),
                onTap: () {
                  Navigator.pop(context);
                  copyInvoiceText(context, saleData);
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart, color: Colors.green),
                title: const Text("Export to Excel (CSV format)"),
                onTap: () {
                  Navigator.pop(context);
                  exportToExcel(saleData);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> generateAndPrintPdf(SaleModel saleData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text("INVOICE RECEIPT",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Customer: ${saleData.customerName ?? 'General'}"),
              pw.Text("Date: ${DateTime.now().toString().substring(0, 16)}"),
              pw.Divider(),
              if (saleData.items != null)
                ...saleData.items!.map((item) => pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                            child: pw.Text(
                                "${item.productName} (x${item.quantity})")),
                        pw.Text("\$${item.totalPrice.toStringAsFixed(2)}"),
                      ],
                    )),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total Amount:",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("\$${saleData.totalAmount.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static Future<void> shareToTelegram(SaleModel saleData) async {
    try {
      bool success = await TelegramServices.sendSaleInvoice(saleData);
      if (success) {
        debugPrint("Successfully sent invoice to Telegram!");
      } else {
        debugPrint("Failed to send invoice to Telegram.");
      }
    } catch (e) {
      debugPrint("Error sharing to Telegram: $e");
    }
  }

  static Future<void> copyInvoiceText(BuildContext context, SaleModel saleData) async {
    String invoiceText = "🧾 INVOICE RECEIPT\n"
        "Customer: ${saleData.customerName ?? 'General'}\n"
        "Date: ${DateTime.now().toString().substring(0, 16)}\n"
        "----------------------------------\n";

    if (saleData.items != null) {
      for (var item in saleData.items!) {
        invoiceText += "${item.productName} (x${item.quantity}) - \$${item.totalPrice.toStringAsFixed(2)}\n";
      }
    }

    invoiceText += "----------------------------------\n"
        "Total Amount: \$${saleData.totalAmount.toStringAsFixed(2)}";

    await Clipboard.setData(ClipboardData(text: invoiceText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("បានចម្លង (Copied) វិក្កយបត្រចូល Clipboard រួចរាល់!"),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  static Future<void> exportToExcel(SaleModel saleData) async {
    try {
      String csvData = "Product Name,Quantity,Unit Price,Total\n";
      if (saleData.items != null) {
        for (var item in saleData.items!) {
          csvData +=
              "${item.productName},${item.quantity},${item.unitPrice},${item.totalPrice}\n";
        }
      }
      csvData += ",,,Total Amount,${saleData.totalAmount}\n";

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/order_report.csv");
      await file.writeAsString(csvData);

      await Share.shareXFiles([XFile(file.path)],
          text: "Here is your order report CSV (Excel compatible).");
    } catch (e) {
      debugPrint("Error exporting Excel: $e");
    }
  }
}