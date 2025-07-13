

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart'; // <--- import GetIt

import 'package:servzz/core/common/my_snackbar.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/home/presentation/view/home_view.dart';
import 'package:servzz/features/home/presentation/view_model/home_state.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';


// Mocks
class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeLoginParams extends Fake implements LoginParams {}

class MockHomeViewModel extends Mock implements HomeViewModel {}

final sl = GetIt.instance;

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  late MockUserLoginUsecase mockUsecase;
  late LoginViewModel loginBloc;
  late MockBuildContext mockContext;
  late MockHomeViewModel mockHomeViewModel;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'abc123token';

  setUp(() {
    mockUsecase = MockUserLoginUsecase();
    loginBloc = LoginViewModel(mockUsecase);
    mockContext = MockBuildContext();
    mockHomeViewModel = MockHomeViewModel();

    when(() => mockContext.mounted).thenReturn(true);

    when(
      () => mockHomeViewModel.stream,
    ).thenAnswer((_) => Stream<HomeState>.empty());
    when(() => mockHomeViewModel.state).thenReturn(HomeState.initial());

    // Register MockHomeViewModel in GetIt before each test
    if (sl.isRegistered<HomeViewModel>()) {
      sl.unregister<HomeViewModel>();
    }
    sl.registerSingleton<HomeViewModel>(mockHomeViewModel);
  });

  tearDown(() {
    // Unregister after each test to avoid conflicts
    if (sl.isRegistered<HomeViewModel>()) {
      sl.unregister<HomeViewModel>();
    }
  });

