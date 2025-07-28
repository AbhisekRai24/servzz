import 'package:equatable/equatable.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? token;
  final UserEntity? user; // Could be logged-in user info
  final UserEntity? currentUser; // Could be currently fetched user info
  final String? message; // For error/success messages

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.token,
    this.user,
    this.currentUser,
    this.message,
  });

  const LoginState.initial()
    : isLoading = false,
      isSuccess = false,
      token = null,
      user = null,
      currentUser = null,
      message = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? token,
    UserEntity? user,
    UserEntity? currentUser,
    String? message,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      token: token ?? this.token,
      user: user ?? this.user,
      currentUser: currentUser ?? this.currentUser,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    token,
    user,
    currentUser,
    message,
  ];
}

// class LoginState extends Equatable {
//   final bool isLoading;
//   final bool isSuccess;
//   final String token;
//   final UserEntity? user;
//   final String message;

//   const LoginState({
//     required this.isLoading,
//     required this.isSuccess,
//     required this.token,
//     this.user,
//     required this.message,
//   });

//   const LoginState.initial()
//     : isLoading = false,
//       isSuccess = false,
//       token = '',
//       user = null,
//       message = '';

//   LoginState copyWith({
//     bool? isLoading,
//     bool? isSuccess,
//     String? token,
//     UserEntity? user,
//     String? message,
//   }) {
//     return LoginState(
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//       token: token ?? this.token,
//       user: user ?? this.user,
//       message: message ?? this.message,
//     );
//   }

//   @override
//   List<Object?> get props => [isLoading, isSuccess, token, user, message];
// }
