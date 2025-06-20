import 'package:dartz/dartz.dart';
import 'package:servzz/app/use_case/usecase.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';
import 'package:servzz/features/auth/domain/repository/user_repository.dart';

class UserGetCurrentUsecase implements UsecaseWithoutParams<UserEntity> {
  final IUserRepository _userRepository;

  UserGetCurrentUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity>> call() {
    return _userRepository.getCurrentUser();
  }
}
