
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:servzz/features/auth/presentation/view/login_view.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:servzz/core/error/failure.dart';

// Mocks
class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}
class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late MockUserLoginUsecase mockUserLoginUsecase;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
  });

  Widget buildLoginScreen() {
    return MaterialApp(
      home: BlocProvider<LoginViewModel>(
        create: (_) => LoginViewModel(mockUserLoginUsecase),
        child: const LoginView(),
      ),
    );
  }

  testWidgets('renders LoginView with email, password fields and login button', (tester) async {
    await tester.pumpWidget(buildLoginScreen());

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text("Login"), findsOneWidget);
    expect(find.text("Don't have an account? Register"), findsOneWidget);
  });

}
