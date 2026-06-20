import 'package:selling_project/services/storage_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton<IStorageService>(() => StorageService());
}
