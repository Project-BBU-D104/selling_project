import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:selling_project/models/sale/sale_model.dart';

class TelegramServices {
  static String get botToken => dotenv.env['TELEGRAM_BOT_TOKEN'] ?? '';
  static String get chatId => dotenv.env['TELEGRAM_CHAT_ID'] ?? '';

  static Future<bool> sendSaleInvoice(SaleModel sale) async {
    if (botToken.isEmpty || chatId.isEmpty) {
      print("Error: Telegram botToken or chatId is missing in .env");
      return false;
    }

    String message = "🧾 *វិក្កយបត្រការលក់ (Sales Invoice)*\n\n"
        "🆔 លេខវិក្កយបត្រ: `${sale.invoiceNo ?? 'N/A'}`\n"
        "👤 អតិថិជន: *${sale.customerName ?? 'General Customer'}*\n"
        "📅 កាលបរិច្ឆេទ: ${sale.saleDate != null ? sale.saleDate.toString().split('.')[0] : 'N/A'}\n"
        "----------------------------------\n";

    if (sale.items != null && sale.items!.isNotEmpty) {
      for (var item in sale.items!) {
        message += "▪️ ${item.productName} (x${item.quantity}) - \$${item.totalPrice.toStringAsFixed(2)}\n";
      }
    } else {
      message += "▪️ គ្មានទំនិញបង្ហាញ\n";
    }

    message += "----------------------------------\n"
        "🏷️ *Subtotal:* \$${sale.subtotal.toStringAsFixed(2)}\n"
        "📉 *Discount:* -\$${sale.discount.toStringAsFixed(2)}\n"
        "📈 *Tax:* \$${sale.tax.toStringAsFixed(2)}\n"
        "💵 *ទឹកប្រាក់សរុប (Total): \$${sale.totalAmount.toStringAsFixed(2)}*\n"
        "💳 *ទូទាត់តាមរយៈ:* ${sale.paymentMethod ?? 'Cash'}";

    final url = Uri.parse("https://api.telegram.org/bot$botToken/sendMessage");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': chatId,
          'text': message,
          'parse_mode': 'Markdown',
        }),
      );

      if (response.statusCode == 200) {
        print("Telegram message sent successfully!");
        return true;
      } else {
        print("Failed to send Telegram message: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending to Telegram: $e");
      return false;
    }
  }
}