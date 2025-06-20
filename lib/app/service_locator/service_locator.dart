import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:servzz/core/network/api_service.dart';
import 'package:servzz/core/network/hive_service.dart';
import 'package:servzz/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:servzz/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:servzz/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';
import 'package:servzz/features/splash/presentation/view/splash_view.dart';
import 'package:servzz/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await initApiModule();
  // Initialize all modules

  await _initAuthModule();
  await _initHomeModule();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> initApiModule() async {
  // Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

Future<void> _initAuthModule() async {
  // ===================== Data Source ====================
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () =>
        UserLoginUsecase(userRepository: serviceLocator<UserLocalRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UploadImageUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(
      serviceLocator<UserRegisterUsecase>(),
      serviceLocator<UploadImageUsecase>(),
    ),
  );

  // Register LoginViewModel WITHOUT HomeViewModel to avoid circular dependency
  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
