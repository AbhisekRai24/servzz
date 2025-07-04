import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(String email, String password);

  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
