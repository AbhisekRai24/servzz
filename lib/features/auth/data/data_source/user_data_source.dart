import 'dart:io';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDatasource {
  Future<void> registerUser(UserEntity studentData);

  Future<String> loginUser(String username, String password);

  Future<String> uploadProfilePicture(File file);

  Future<UserEntity> getCurrentUser();
}
