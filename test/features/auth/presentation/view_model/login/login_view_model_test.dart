// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:dartz/dartz.dart';
// import 'package:get_it/get_it.dart'; // <--- import GetIt

// import 'package:servzz/core/common/my_snackbar.dart';
// import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_event.dart';
// import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_state.dart';
// import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
// import 'package:servzz/core/error/failure.dart';
// import 'package:servzz/features/home/presentation/view/home_view.dart';
// import 'package:servzz/features/home/presentation/view_model/home_state.dart';
// import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';

// // Mocks
// class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

// class MockBuildContext extends Mock implements BuildContext {}

// class FakeLoginParams extends Fake implements LoginParams {}

// class MockHomeViewModel extends Mock implements HomeViewModel {}

// final sl = GetIt.instance;

// void main() {
//   setUpAll(() {
//     registerFallbackValue(FakeLoginParams());
//   });

//   late MockUserLoginUsecase mockUsecase;
//   late LoginViewModel loginBloc;
//   late MockBuildContext mockContext;
//   late MockHomeViewModel mockHomeViewModel;

//   const testEmail = 'test@example.com';
//   const testPassword = 'password123';
//   const testToken = 'abc123token';

//   setUp(() {
//     mockUsecase = MockUserLoginUsecase();
//     loginBloc = LoginViewModel(mockUsecase);
//     mockContext = MockBuildContext();
//     mockHomeViewModel = MockHomeViewModel();

//     when(() => mockContext.mounted).thenReturn(true);

//     when(
//       () => mockHomeViewModel.stream,
//     ).thenAnswer((_) => Stream<HomeState>.empty());
//     when(() => mockHomeViewModel.state).thenReturn(HomeState.initial());

//     // Register MockHomeViewModel in GetIt before each test
//     if (sl.isRegistered<HomeViewModel>()) {
//       sl.unregister<HomeViewModel>();
//     }
//     sl.registerSingleton<HomeViewModel>(mockHomeViewModel);
//   });

//   tearDown(() {
//     // Unregister after each test to avoid conflicts
//     if (sl.isRegistered<HomeViewModel>()) {
//       sl.unregister<HomeViewModel>();
//     }
//   });
//   group('LoginViewModel', () {
//     testWidgets('login success navigates to HomeView', (tester) async {
//       when(
//         () => mockUsecase.call(any()),
//       ).thenAnswer((_) async => const Right(testToken));

//       // Use the loginBloc with registered mocks
//       final loginBloc = LoginViewModel(mockUsecase);

//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<LoginViewModel>.value(
//             value: loginBloc,
//             child: Builder(
//               builder: (context) {
//                 // Fire login event with context that has Navigator
//                 loginBloc.add(
//                   LoginWithEmailAndPasswordEvent(
//                     context: context,
//                     email: testEmail,
//                     password: testPassword,
//                   ),
//                 );
//                 return Container();
//               },
//             ),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();

//       // Assert HomeView is shown (means navigation happened)
//       expect(find.byType(HomeView), findsOneWidget);
//     });

//     testWidgets('shows SnackBar when login fails', (tester) async {
//       when(() => mockUsecase.call(any())).thenAnswer(
//         (_) async => const Left(RemoteDatabaseFailure(message: 'Login failed')),
//       );

//       final loginBloc = LoginViewModel(mockUsecase);

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: BlocProvider<LoginViewModel>.value(
//               value: loginBloc,
//               child: Builder(
//                 builder: (context) {
//                   loginBloc.add(
//                     LoginWithEmailAndPasswordEvent(
//                       context: context,
//                       email: testEmail,
//                       password: testPassword,
//                     ),
//                   );
//                   return Container();
//                 },
//               ),
//             ),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();

//       // Verify snackbar with error message appears
//       expect(find.text('Login failed'), findsOneWidget);
//     });

//     blocTest<LoginViewModel, LoginState>(
//       'emits [loading, failure] when login fails',
//       build: () {
//         when(() => mockUsecase.call(any())).thenAnswer(
//           (_) async =>
//               const Left(RemoteDatabaseFailure(message: 'Login failed')),
//         );
//         return LoginViewModel(mockUsecase);
//       },
//       act:
//           (bloc) => bloc.add(
//             LoginWithEmailAndPasswordEvent(
//               context: mockContext,
//               email: testEmail,
//               password: testPassword,
//             ),
//           ),
//       expect:
//           () => [
//             const LoginState(isLoading: true, isSuccess: false),
//             const LoginState(isLoading: false, isSuccess: false),
//           ],
//     );
//   });
// }
