import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:servzz/app/use_case/usecase.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/domain/repository/user_repository.dart';

class UploadImageParams {
  final File file;

  const UploadImageParams({required this.file});
}

class UploadImageUsecase
    implements UsecaseWithParams<String, UploadImageParams> {
  final IUserRepository _userRepository;

  UploadImageUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
    return _userRepository.uploadProfilePicture(params.file);
  }
}
