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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initStorage();
  await GetStorage.init();
  Get.put(AppController());

  await dotenv.load(fileName: "assets/.env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

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
    final box = GetStorage();
    bool isDarkModeSaved = box.read('isDarkMode') ?? false;

    return GetMaterialApp(
      title: 'Selling Project',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      
      themeMode: isDarkModeSaved ? ThemeMode.dark : ThemeMode.light,

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