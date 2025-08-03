import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:servzz/app/constant/api_endpoints.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/app/themes/view_model/theme_bloc.dart';

import 'package:servzz/core/network/api_service.dart';
import 'package:servzz/core/network/dio_error_interceptor.dart';
import 'package:servzz/core/network/hive_service.dart';
import 'package:servzz/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:servzz/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:servzz/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:servzz/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:servzz/features/auth/domain/use_case/update_user_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';

import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';
import 'package:servzz/features/home/presentation/view_model/update_viewmodel/update_viewmodel.dart';
import 'package:servzz/features/order/data/data_source/order_datasource.dart';
import 'package:servzz/features/order/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:servzz/features/order/data/repository/remote_repository/order_remote_repository.dart';
import 'package:servzz/features/order/domain/repository/order_repository.dart';
import 'package:servzz/features/order/domain/use_case/create_order_usecase.dart';
import 'package:servzz/features/order/domain/use_case/get_order_usecase.dart';
import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
import 'package:servzz/features/product/data/data_source/product_remote_data_source.dart';
import 'package:servzz/features/product/data/repository/remote_repository/product_remote_repository.dart';
import 'package:servzz/features/product/domain/repository/product_repository.dart';
import 'package:servzz/features/product/domain/use_case/product_fetch_usecase.dart';
import 'package:servzz/features/product/presentation/view_model/product_view_model.dart';
import 'package:servzz/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ),
    );

    dio.interceptors.add(DioErrorInterceptor()); // ✅ add the interceptor
    return dio;
  });
  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
  await _initHiveService();
  await _initApiService();
  // await initApiModule();
  await _initSharedPrefs();
  await _initAuthModule();
  await _initHomeModule();
  await _initSplashModule();
  await _initProductModule();
  await _initThemeModule();

  await _initCartModule();
  await _initOrderModule();
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
    () => UserRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
      dio: serviceLocator<Dio>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
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
  //   () => UserLoginUsecase(
  //     remoteRepository: serviceLocator<UserRemoteRepository>(),
  //     localRepository: serviceLocator<UserLocalRepository>(),
  //     tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
  //   ),
  // );

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
    () => UpdateUserUsecase(
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
    () => LoginViewModel(
      serviceLocator<UserLoginUsecase>(),
      serviceLocator<UserGetCurrentUsecase>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpdateUserViewModel(
      updateUserUsecase: serviceLocator<UpdateUserUsecase>(),
    ),
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

Future<void> _initCartModule() async {
  // Register CartViewModel (Bloc)
  serviceLocator.registerFactory<CartViewModel>(() => CartViewModel());

  // If you have Cart-related use cases or repositories, register them here as well
  // e.g. serviceLocator.registerFactory<CartRepository>(() => CartRepositoryImpl());
  // Then inject those into CartViewModel's constructor
}

Future<void> _initThemeModule() async {
  serviceLocator.registerFactory(() => ThemeBloc());
}

Future<void> _initOrderModule() async {
  // data source
  print("Registering OrderRemoteDataSource");
  serviceLocator.registerFactory<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(serviceLocator<Dio>()),
  );

  // repository
  print("Registering OrderRepository");
  serviceLocator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(serviceLocator<OrderRemoteDataSource>()),
  );

  // use case
  print("Registering CreateOrderUseCase");
  serviceLocator.registerFactory<CreateOrderUseCase>(
    () => CreateOrderUseCase(serviceLocator<OrderRepository>()),
  );

  serviceLocator.registerFactory<GetUserOrdersUseCase>(
    () => GetUserOrdersUseCase(serviceLocator<OrderRepository>()),
  );

  //bloc

  print("Registering OrderViewModel");
  serviceLocator.registerFactory<OrderViewModel>(
    () => OrderViewModel(
      createOrderUseCase: serviceLocator<CreateOrderUseCase>(),
      getUserOrdersUseCase: serviceLocator<GetUserOrdersUseCase>(),
    ),
  );
}
