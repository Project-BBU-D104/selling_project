import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Get.put(AppController());
  runApp(const MyApp());
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

      initialRoute: AppRoute.splash,
      getPages: AppScreen.pages,
      
    );
  }
}
  