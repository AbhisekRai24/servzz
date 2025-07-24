import 'package:equatable/equatable.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;

  const LoginState({required this.isLoading, required this.isSuccess});

  const LoginState.initial() : isLoading = false, isSuccess = false;

  LoginState copyWith({bool? isLoading, bool? isSuccess}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess];
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
