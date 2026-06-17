import 'package:flutter/material.dart';

class StockAdjustmentScreen extends StatelessWidget {
  const StockAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock Adjustment")),
      body: Text("This is stock adjustment"),
    );
  }
}