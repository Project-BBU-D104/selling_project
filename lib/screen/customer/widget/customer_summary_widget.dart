import 'package:flutter/material.dart';

class CustomerSummaryWidget extends StatelessWidget {
  final int totalCustomers;
  const CustomerSummaryWidget({super.key, required this.totalCustomers});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'TOTAL CUSTOMERS',
            value: totalCustomers.toString(),
            bgColor: const Color(0xFF005293),
            textColor: Colors.white,
            lblColor: Colors.white70,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'HIGH RECEIVABLES',
            value: '\$12.4k',
            bgColor: const Color(0xFFFEE2E2),
            textColor: const Color(0xFF991B1B),
            lblColor: const Color(0xFF991B1B),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({required String title, required String value, required Color bgColor, required Color textColor, required Color lblColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: lblColor, letterSpacing: 0.5),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}