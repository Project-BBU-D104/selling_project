import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selling_project/controller/app_controller.dart';
import 'package:selling_project/firebase_options.dart';
import 'package:selling_project/routes/app_route.dart';
import 'package:selling_project/routes/app_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
_initStorage();
      await GetStorage.init();
  Get.put(AppController());
  runApp(const MyApp());
}
 

/// Init local storage on app startup
Future<void> _initStorage() async {
  const boxName = ".appsettings";
  if (kIsWeb) {
    await GetStorage.init(boxName);
  } else if (Platform.isWindows) {
    final dir = "${Directory.current.path}\\.config";
    final directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    await GetStorage(".appsettings", dir).initStorage;
  } else {
    await GetStorage.init(boxName);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Selling Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),

      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
        },
      ),

      initialRoute: AppRoute.splash,
      getPages: AppScreen.pages,
      
    );
  }
}
  