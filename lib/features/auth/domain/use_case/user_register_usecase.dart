import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:servzz/app/use_case/usecase.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';
import 'package:servzz/features/auth/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String firstname;
  final String lastname;
  final String? phone;

  final String username;
  final String email;
  final String password;
  final String? image;

  const RegisterUserParams({
    required this.firstname,
    required this.lastname,
    this.phone,

    required this.username,
    required this.email,
    required this.password,
    this.image,
  });

  //intial constructor
  const RegisterUserParams.initial({
    required this.firstname,
    required this.lastname,
    this.phone,

    required this.username,
    required this.email,

    required this.password,
    this.image,
  });

  @override
  List<Object?> get props => [firstname, lastname, phone, username, email, password ];
}

class UserRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      firstName: params.firstname,
      lastName: params.lastname,
      phone: params.phone,

      username: params.username,
      email: params.email,
      password: params.password,
      image: params.image,
    );
    return _userRepository.registerUser(userEntity);
  }
}
