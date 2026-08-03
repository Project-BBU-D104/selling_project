import 'package:flutter/foundation.dart';

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