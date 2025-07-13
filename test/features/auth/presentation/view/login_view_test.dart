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

  testWidgets(
    'renders LoginView with email, password fields and login button',
    (tester) async {
      await tester.pumpWidget(buildLoginScreen());

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text("Login"), findsOneWidget);
      expect(find.text("Don't have an account? Register"), findsOneWidget);
    },
  );

  testWidgets('shows snackbar on login failure', (tester) async {
    when(() => mockUserLoginUsecase(any())).thenAnswer(
      (_) async => const Left(RemoteDatabaseFailure(message: "Login failed")),
    );

    await tester.pumpWidget(buildLoginScreen());

    await tester.enterText(find.byType(TextFormField).at(0), 'wrong@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
    await tester.tap(find.text('Login'));

    await tester.pumpAndSettle(); // Wait for animations and snackbar

    expect(find.text('Invalid credentials. Please try again.'), findsOneWidget);
  });
  // testWidgets('navigates to HomeView on successful login', (tester) async {
  //   when(() => mockUserLoginUsecase(any()))
  //       .thenAnswer((_) async => const Right("mock_token"));

  //   await tester.pumpWidget(buildLoginScreen());

  //   await tester.enterText(find.byType(TextFormField).at(0), 'test@email.com');
  //   await tester.enterText(find.byType(TextFormField).at(1), 'correctpassword');
  //   await tester.tap(find.text('Login'));

  //   await tester.pumpAndSettle();

  //   // Check for some widget or behavior from HomeView
  //   expect(find.byType(Scaffold), findsWidgets); // You can add more accurate checks
  // });
}
