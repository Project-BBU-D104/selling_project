import 'package:selling_project/locator.dart';
import 'package:selling_project/services/storage_service.dart';
import 'package:selling_project/utils/helper.dart';

final storage = locator<IStorageService>();
final helper = Helper();


/// AES Decrypt method
String eDecrypted(String encrypted) {
  return helper.onDecrypted(encrypted);
}

/// AES Encrypt method
String eEcrypted(String plainText) {
  return helper.onEncrypted(plainText);
}