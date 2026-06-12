import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:selling_project/routes/app_route.dart';

class AppController extends ChangeNotifier {
  bool isLoading = true;   
  bool settingLoadCompleted = false;
 
  
  AppController() {
    onInitState();
  }

  Future<void> onInitState() async {

    if (isLoading) {
      await Future.delayed(const Duration(milliseconds: 1500));
    }
 
    Get.offAllNamed(AppRoute.login);
    
    isLoading = false;
    notifyListeners();

    if (kDebugMode) {
      print("Init App");
    }
  }

  
  @override
  void dispose() {
    if (kDebugMode) {
      print("Close App");
    }

    super.dispose();
  }
}