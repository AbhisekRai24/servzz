// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:dartz/dartz.dart';

// import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
// import 'package:servzz/features/auth/presentation/view/login_view.dart';
// import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_event.dart';
// import 'package:servzz/core/error/failure.dart';

// // Mocks
// class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

// class FakeLoginParams extends Fake implements LoginParams {}

// void main() {
//   late MockUserLoginUsecase mockUserLoginUsecase;

//   setUpAll(() {
//     registerFallbackValue(FakeLoginParams());
//   });

//   setUp(() {
//     mockUserLoginUsecase = MockUserLoginUsecase();
//   });

//   Widget buildLoginScreen() {
//     return MaterialApp(
//       home: BlocProvider<LoginViewModel>(
//         create: (_) => LoginViewModel(mockUserLoginUsecase),
//         child: const LoginView(),
//       ),
//     );
//   }

//   group('LoginView Widget Tests Sprint 5', () {
//     testWidgets(
//       'renders LoginView with email, password fields and login button',
//       (tester) async {
//         await tester.pumpWidget(buildLoginScreen());

//         expect(find.byType(TextFormField), findsNWidgets(2));
//         expect(find.text("Login"), findsOneWidget);
//         expect(find.text("Don't have an account? Register"), findsOneWidget);
//       },
//     );

//     testWidgets('shows snackbar on login failure', (tester) async {
//       when(() => mockUserLoginUsecase(any())).thenAnswer(
//         (_) async => const Left(RemoteDatabaseFailure(message: "Login failed")),
//       );

//       await tester.pumpWidget(buildLoginScreen());

//       await tester.enterText(
//         find.byType(TextFormField).at(0),
//         'wrong@email.com',
//       );
//       await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
//       await tester.tap(find.text('Login'));

//       await tester.pumpAndSettle(); // Wait for animations and snackbar

//       expect(
//         find.text('Invalid credentials. Please try again.'),
//         findsOneWidget,
//       );
//     });

//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:servzz/features/auth/presentation/view/login_view.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/core/error/failure.dart';

// Mocks and Fakes
// ------------------------
class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class MockUserGetCurrentUsecase extends Mock implements UserGetCurrentUsecase {}

class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late MockUserLoginUsecase mockUserLoginUsecase;
  late MockUserGetCurrentUsecase mockUserGetCurrentUsecase;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
    mockUserGetCurrentUsecase = MockUserGetCurrentUsecase();

    final dummyUser = UserEntity(
      userId: '1',
      username: 'Test User',
      email: 'test@example.com',
    );

    when(
      () => mockUserGetCurrentUsecase(),
    ).thenAnswer((_) async => Right(dummyUser));
  });

  Widget buildLoginScreen() {
    return MaterialApp(
      home: BlocProvider<LoginViewModel>(
        create:
            (_) =>
                LoginViewModel(mockUserLoginUsecase, mockUserGetCurrentUsecase),
        child: const LoginView(),
      ),
    );
  }

  group('LoginView Widget Tests Sprint 5', () {
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

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'wrong@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
      await tester.tap(find.text('Login'));

      await tester.pumpAndSettle(); // Wait for animations and snackbar

      expect(
        find.text('Invalid credentials. Please try again.'),
        findsOneWidget,
      );
    });
  });
}
