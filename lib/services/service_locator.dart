import 'package:get_it/get_it.dart';
import 'package:yaanyo/services/auth_service.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/services/shared_pref_service.dart';

final serviceLocator = GetIt.instance;

void initServiceLocator() {
  serviceLocator.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  serviceLocator.registerLazySingleton<DatabaseService>(
    () => DatabaseService(),
  );

  serviceLocator.registerLazySingleton<SharedPrefService>(
    () => SharedPrefService(),
  );
}
