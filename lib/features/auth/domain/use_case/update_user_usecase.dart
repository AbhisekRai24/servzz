import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:servzz/app/use_case/usecase.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';
import 'package:servzz/features/auth/domain/repository/user_repository.dart';

class UpdateUserParams extends Equatable {
  final UserEntity userData;
  final File? profileImage;

  const UpdateUserParams({required this.userData, this.profileImage});

  const UpdateUserParams.initial()
    : userData = const UserEntity(),
      profileImage = null;

  @override
  List<Object?> get props => [userData, profileImage];
}

class UpdateUserUsecase
    implements UsecaseWithParams<UserEntity, UpdateUserParams> {
  final IUserRepository _userRepository;

  UpdateUserUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) async {
    final result = await _userRepository.updateUser(
      params.userData,
      profileImage: params.profileImage,
    );

    return result.fold(
      (failure) => Left(failure),
      (updatedUser) => Right(updatedUser),
    );
  }
}
