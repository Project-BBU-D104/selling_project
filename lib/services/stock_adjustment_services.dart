import 'package:selling_project/models/stock_adjustment_model.dart';
import 'package:selling_project/services/api_services.dart';

class StockAdjustmentServices {
  final ApiServices api = ApiServices();
  final String collection = "stock_adjustments";
  final String productCollection = "products";

  Stream<List<StockAdjustmentModel>> getStockAdjustments() {
    return api.get(collection).map((data) {
      return data.map((item) {
        return StockAdjustmentModel.fromJson(item);
      }).toList();
    });
  }

  Future<String> addStockAdjustment(
      StockAdjustmentModel stockAdjustment, int currentProductQuantity) async {
    final String id = await api.post(
      collection,
      stockAdjustment.toJson(),
    );

    int newQuantity = currentProductQuantity;
    if (stockAdjustment.adjustmentType == 'ADD') {
      newQuantity += stockAdjustment.quantity;
    } else if (stockAdjustment.adjustmentType == 'SUBTRACT') {
      newQuantity -= stockAdjustment.quantity;
      if (newQuantity < 0) {
        throw Exception("Quantity cannot be negative after subtraction.");
      }
    }

    await api.put(
      productCollection,
      stockAdjustment.productId,
      {
        'quantity': newQuantity,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );

    return id;
  }

  // UPDATE
  Future<void> updateStockAdjustment(
      StockAdjustmentModel stockAdjustment) async {
    await api.put(
      collection,
      stockAdjustment.id!,
      stockAdjustment.toJson(),
    );
  }

  // DELETE
  Future<void> deleteStockAdjustment(String id) async {
    await api.delete(
      collection,
      id,
    );
  }
}