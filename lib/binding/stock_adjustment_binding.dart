import 'package:get/get.dart';
import 'package:selling_project/controller/stock_adjustment_controller.dart';

class StockAdjustmentBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<StockAdjustmentController>(() => StockAdjustmentController(),
    );
  }
}