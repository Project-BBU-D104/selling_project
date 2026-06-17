import 'package:get/get.dart';
import 'package:selling_project/controller/payment_controller.dart';

class PaymentBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController(),
    );
  }
}