// Material app
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/app/themes/theme_data.dart';
import 'package:servzz/features/auth/presentation/view/login_view.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/splash/presentation/view/splash_view.dart';
import 'package:servzz/features/splash/presentation/view_model/splash_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // main theme of the app
      // theme as in the customizable themes in androids
      theme: getApplicationTheme(),
      debugShowCheckedModeBanner: false,
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashView(),
      ),
    );
  }
}
