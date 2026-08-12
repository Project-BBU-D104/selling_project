import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selling_project/models/report/report_detail_model.dart';

class ReportSalesTableWidget extends StatelessWidget {
  final List<SalesTransactionModel> transactions;

  const ReportSalesTableWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    if (transactions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text("No sales records found")),
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Invoice #', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Profit', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: transactions.map((item) {
            return DataRow(cells: [
              DataCell(Text('#${item.invoiceNo}', style: const TextStyle(fontWeight: FontWeight.w600))),
              DataCell(Text(dateFormat.format(item.date))),
              DataCell(Text('${item.totalQty}')),
              DataCell(Text(currencyFormat.format(item.profit), style: const TextStyle(color: Colors.blue))),
              DataCell(Text(
                currencyFormat.format(item.grandTotal),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}