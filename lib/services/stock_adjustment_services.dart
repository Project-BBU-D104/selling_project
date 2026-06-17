import 'package:selling_project/models/stock_adjustment_model.dart';
import 'package:selling_project/services/api_services.dart';
class StockAdjustmentServices {

  final ApiServices api = ApiServices();
  final String collection = "stock_adjustments";

  // GET
  Stream<List<StockAdjustmentModel>> getStockAdjustments() {
    return api
        .get(collection)
        .map((data){
          return data.map((item){
            return StockAdjustmentModel.fromJson(
              item,
              item["id"]
            );
          }).toList();
        });
  }
  // POST
  Future<String> addBrand(
      StockAdjustmentModel stockAdjustment
  ) async {
    return await api.post(
      collection,
      stockAdjustment.toJson()
    );
  }
  // UPDATE
  Future<void> updateBrand(
      StockAdjustmentModel stockAdjustment
  ) async {
    await api.put(
      collection,
      stockAdjustment.id!,
      stockAdjustment.toJson()
    );
  }
  // DELETE
  Future<void> deleteStockAdjustment(
      String id
  ) async {
    await api.delete(
      collection,
      id
    );
  }
}