import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';

import 'package:servzz/core/network/api_service.dart';
import 'package:servzz/core/network/hive_service.dart';
import 'package:servzz/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:servzz/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:servzz/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:servzz/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:servzz/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:servzz/features/home/data/data_source/product_remote_data_source.dart';
import 'package:servzz/features/home/data/repository/remote_repository/product_remote_repository.dart';
import 'package:servzz/features/home/domain/repository/product_repository.dart';
import 'package:servzz/features/home/domain/use_case/product_fetch_usecase.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';
import 'package:servzz/features/home/presentation/view_model/product_view_model.dart';
import 'package:servzz/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
  await _initHiveService();
  await _initApiService();
  // await initApiModule();
  await _initSharedPrefs();
  await _initAuthModule();
  await _initHomeModule();
  await _initSplashModule();
  await _initProductModule();
}

Future<void> _initSharedPrefs() async {
  // Initialize Shared Preferences if needed
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

// Future<void> initApiModule() async {
//   // Dio instance
//   serviceLocator.registerLazySingleton<Dio>(() => Dio());
//   serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
// }
Future<void> _initProductModule() async {
  // Remote Data Source
  serviceLocator.registerFactory<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: serviceLocator<http.Client>()),
  );

  // Repository
  serviceLocator.registerFactory<IProductRepository>(
    () => ProductRemoteRepository(
      productRemoteDataSource: serviceLocator<ProductRemoteDataSource>(),
    ),
  );

  // Usecase
  serviceLocator.registerFactory(
    () => FetchProductsUsecase(
      productRepository: serviceLocator<IProductRepository>(),
    ),
  );

  // Bloc
  serviceLocator.registerFactory(
    () => ProductBloc(serviceLocator<FetchProductsUsecase>()),
  );
}

Future<void> _initAuthModule() async {
  // Data

  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repository

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDataSource: serviceLocator<UserRemoteDataSource>(),
    ),
  );

  // Usecases

  // serviceLocator.registerFactory(
  //   () =>
  //       UserLoginUsecase(userRepository: serviceLocator<UserLocalRepository>()),
  // );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // serviceLocator.registerFactory(
  //   () => UserRegisterUsecase(
  //     userRepository: serviceLocator<UserLocalRepository>(),
  //   ),
  // );

  // serviceLocator.registerFactory(
  //   () => UploadImageUsecase(
  //     userRepository: serviceLocator<UserLocalRepository>(),
  //   ),
  // );

  // serviceLocator.registerFactory(
  //   () => UserGetCurrentUsecase(
  //     userRepository: serviceLocator<UserLocalRepository>(),
  //   ),
  // );

  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UploadImageUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
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

// Future<void> _initHomeModule() async {
//   serviceLocator.registerFactory(
//     () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
//   );
// }

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(
      loginViewModel: serviceLocator<LoginViewModel>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
