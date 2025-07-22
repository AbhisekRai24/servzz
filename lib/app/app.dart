// Material app
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/app/themes/theme_data.dart';
import 'package:servzz/features/auth/presentation/view/login_view.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:servzz/features/order/presentation/view_model/order_view_model.dart';
import 'package:servzz/features/splash/presentation/view/splash_view.dart';
import 'package:servzz/features/splash/presentation/view_model/splash_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Or create manually:
          // create: (_) => OrderViewModel(createOrderUseCase: serviceLocator<CreateOrderUseCase>()),
        ),
        
      ],
      child: MaterialApp(
        theme: getApplicationTheme(),
        debugShowCheckedModeBanner: false,
        home: SplashView(),
      ),
    );
  }
}
