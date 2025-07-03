import 'dart:io';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDatasource {
  Future<void> registerUser(UserEntity userData);

  Future<String> loginUser(String email, String password);

  Future<String> uploadProfilePicture(File file);

  Future<UserEntity> getCurrentUser();
}
