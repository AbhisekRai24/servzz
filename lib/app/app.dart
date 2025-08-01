// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:servzz/app/service_locator/service_locator.dart';
// import 'package:servzz/app/themes/theme_data.dart';
// import 'package:servzz/features/auth/presentation/view/login_view.dart';
// import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
// import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';
// import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
// import 'package:servzz/features/splash/presentation/view/splash_view.dart';
// import 'package:servzz/features/splash/presentation/view_model/splash_view_model.dart';

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<SplashViewModel>(
//           create: (_) => serviceLocator<SplashViewModel>(),
//         ),
//         BlocProvider<LoginViewModel>(
//           create: (_) => serviceLocator<LoginViewModel>(),
//         ),
//         BlocProvider<CartViewModel>(
//           create: (_) => serviceLocator<CartViewModel>(),
//         ),
//         BlocProvider<OrderViewModel>(
//           create: (_) => serviceLocator<OrderViewModel>(),
//           // Or create manually:
//           // create: (_) => OrderViewModel(createOrderUseCase: serviceLocator<CreateOrderUseCase>()),
//         ),
//         BlocProvider<HomeViewModel>(
//           // ✅ Provide this here
//           create: (_) => serviceLocator<HomeViewModel>(),
//         ),
//       ],
//       child: MaterialApp(
//         theme: getApplicationTheme(),
//         debugShowCheckedModeBanner: false,
//         home: SplashView(),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/app/themes/theme_data.dart';
import 'package:servzz/app/themes/view_model/theme_bloc.dart';
import 'package:servzz/app/themes/view_model/theme_event.dart';
import 'package:servzz/app/themes/view_model/theme_state.dart';
import 'package:servzz/core/common/sensor/LightSensor.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';
import 'package:servzz/features/auth/domain/use_case/update_user_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_get_current_usecase.dart';

import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';
import 'package:servzz/features/home/presentation/view_model/update_viewmodel/update_event.dart';
import 'package:servzz/features/home/presentation/view_model/update_viewmodel/update_viewmodel.dart';
import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
import 'package:servzz/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:servzz/features/splash/presentation/view/splash_view.dart';

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   final LightSensorService _sensor = LightSensorService();

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final themeBloc = context.read<ThemeBloc>();
//       themeBloc.add(SetThemeEvent(themeMode: ThemeMode.system));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // BlocProvider<ThemeBloc>(create: (_) => serviceLocator<ThemeBloc>()),
//         BlocProvider<SplashViewModel>(
//           create: (_) => serviceLocator<SplashViewModel>(),
//         ),
//         BlocProvider<LoginViewModel>(
//           create: (_) => serviceLocator<LoginViewModel>(),
//         ),
//         BlocProvider<CartViewModel>(
//           create: (_) => serviceLocator<CartViewModel>(),
//         ),
//         BlocProvider<OrderViewModel>(
//           create: (_) => serviceLocator<OrderViewModel>(),
//         ),
//         BlocProvider<HomeViewModel>(
//           create: (_) => serviceLocator<HomeViewModel>(),
//         ),
//         BlocProvider<UpdateUserViewModel>(
//           create:
//               (context) => UpdateUserViewModel(
//                 updateUserUsecase: serviceLocator<UpdateUserUsecase>(),
//               )..add(InitializeUserDataEvent(currentUser)),
//         ),
//       ],
//       child: BlocBuilder<ThemeBloc, ThemeState>(
//         builder: (context, themeState) {
//           return MaterialApp(
//             theme: getApplicationTheme(), // light theme
//             darkTheme: ThemeData.dark(), // dark theme
//             themeMode: themeState.themeMode,
//             debugShowCheckedModeBanner: false,
//             home: const SplashView(),
//           );
//         },
//       ),
//     );
//   }
// }
class App extends StatelessWidget {
  const App({super.key});

  Future<UserEntity?> _fetchCurrentUser() async {
    final getCurrentUserUsecase = serviceLocator<UserGetCurrentUsecase>();
    final result = await getCurrentUserUsecase();
    return result.fold((failure) => null, (user) => user);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserEntity?>(
      future: _fetchCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Show splash or loading while fetching
          return const MaterialApp(
            home: SplashView(),
            debugShowCheckedModeBanner: false,
          );
        }

        final currentUser = snapshot.data;

        return MultiBlocProvider(
          providers: [
            BlocProvider<SplashViewModel>(
              create: (_) => serviceLocator<SplashViewModel>(),
            ),
            BlocProvider<LoginViewModel>(
              create: (_) => serviceLocator<LoginViewModel>(),
            ),
            BlocProvider<CartViewModel>(
              create: (_) => serviceLocator<CartViewModel>(),
            ),
            BlocProvider<OrderViewModel>(
              create: (_) => serviceLocator<OrderViewModel>(),
            ),
            BlocProvider<HomeViewModel>(
              create: (_) => serviceLocator<HomeViewModel>(),
            ),
            BlocProvider<UpdateUserViewModel>(
              create: (_) {
                final updateUserVM = UpdateUserViewModel(
                  updateUserUsecase: serviceLocator<UpdateUserUsecase>(),
                );
                if (currentUser != null) {
                  updateUserVM.add(InitializeUserDataEvent(currentUser));
                }
                return updateUserVM;
              },
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                theme: getApplicationTheme(),
                darkTheme: ThemeData.dark(),
                themeMode: themeState.themeMode,
                debugShowCheckedModeBanner: false,
                home: const SplashView(),
              );
            },
          ),
        );
      },
    );
  }
}
