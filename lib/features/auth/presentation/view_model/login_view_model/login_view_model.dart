import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/core/common/my_snackbar.dart';
import 'package:servzz/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:servzz/features/auth/presentation/view/register_view.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:servzz/features/home/presentation/view/home_view.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _studentLoginUsecase;
  final UserGetCurrentUsecase _getCurrentUserUsecase;

  LoginViewModel(this._studentLoginUsecase, this._getCurrentUserUsecase)
    : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<NavigateToHomeViewEvent>(_onNavigateToHomeView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
    on<FetchCurrentUserEvent>(_onFetchCurrentUser);
  }
  void _onFetchCurrentUser(
  FetchCurrentUserEvent event,
  Emitter<LoginState> emit,
) async {
  emit(state.copyWith(isLoading: true));

  final result = await _getCurrentUserUsecase();

  result.fold(
    (failure) {
      emit(state.copyWith(isLoading: false));
      showMySnackBar(
        context: event.context,
        message: 'Failed to load user info: ${failure.message}',
        color: Colors.red,
      );
    },
    (user) {
      emit(state.copyWith(isLoading: false, currentUser: user));
    },
  );
}


  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,

        MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  // BlocProvider.value(value: serviceLocator<BatchViewModel>()),
                  // BlocProvider.value(value: serviceLocator<CourseViewModel>()),
                  BlocProvider.value(
                    value: serviceLocator<RegisterViewModel>(),
                  ),
                ],
                child: RegisterView(),
              ),
        ),
      );
    }
  }

  void _onNavigateToHomeView(
    NavigateToHomeViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<HomeViewModel>(),
                child: const HomeView(),
              ),
        ),
      );
    }
  }

  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _studentLoginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        // Handle failure case
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) {
        // Handle success case
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: 'Login Success',
          color: Colors.red,
        );
        add(NavigateToHomeViewEvent(context: event.context));
      },
    );
  }
  // void _onLoginWithEmailAndPassword(
  //   LoginWithEmailAndPasswordEvent event,
  //   Emitter<LoginState> emit,
  // ) async {
  //   emit(state.copyWith(isLoading: true));

  //   final result = await _studentLoginUsecase(
  //     LoginParams(email: event.email, password: event.password),
  //   );

  //   result.fold(
  //     (failure) {
  //       emit(state.copyWith(isLoading: false, isSuccess: false));
  //       showMySnackBar(
  //         context: event.context,
  //         message: 'Invalid credentials. Please try again.',
  //         color: Colors.red,
  //       );
  //     },
  //     (loginResponse) {
  //       // Convert UserApiModel to UserEntity before saving in state
  //       final userEntity = loginResponse.data.toEntity();

  //       emit(state.copyWith(
  //         isLoading: false,
  //         isSuccess: true,
  //         token: loginResponse.token,
  //         user: userEntity,
  //         message: loginResponse.message,
  //       ));

  //       add(NavigateToHomeViewEvent(context: event.context));
  //     },
  //   );
  // }
}
