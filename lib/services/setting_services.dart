import 'package:get_storage/get_storage.dart';

class SettingServices {
  final _storage = GetStorage();
  
  void saveDarkMode(bool value) => _storage.write('isDarkMode', value);
  bool getDarkMode() => _storage.read('isDarkMode') ?? false;
}