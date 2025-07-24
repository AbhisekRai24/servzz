import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/app/use_case/usecase.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/data/model/login_response_model.dart';
import 'package:servzz/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:servzz/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:servzz/features/auth/domain/repository/user_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  const LoginParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUsecase implements UsecaseWithParams<String, LoginParams> {
  final IUserRepository _userRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLoginUsecase({
    required IUserRepository userRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _userRepository = userRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  // Future<Either<Failure, String>> call(LoginParams params) async {
  //   final result = await _userRepository.loginUser(
  //     params.email,
  //     params.password,
  //   );
  //   return result.fold(
  //     (failure) => Left(failure),
  //     (token) async {
  //       await _tokenSharedPrefs.saveToken(token);
  //       return Right(token);
  //     },
  //   );
  // }
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result = await _userRepository.loginUser(
      params.email,
      params.password,
    );

    return await result.fold((failure) async => Left(failure), (token) async {
      await _tokenSharedPrefs.saveToken(token);
      return Right(token);
    });
  }
}
