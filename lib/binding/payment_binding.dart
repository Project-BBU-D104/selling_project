import 'package:get/get.dart';
import 'package:selling_project/controller/payment_controller.dart';
import 'package:selling_project/controller/sale_controller.dart';

class PaymentBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());
    Get.lazyPut<SaleController>(() => SaleController());
  }
}