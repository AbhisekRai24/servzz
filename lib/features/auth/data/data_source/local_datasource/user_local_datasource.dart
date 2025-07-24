import 'dart:io';

import 'package:servzz/core/network/hive_service.dart';
import 'package:servzz/features/auth/data/data_source/user_data_source.dart';
import 'package:servzz/features/auth/data/model/login_response_model.dart';
import 'package:servzz/features/auth/data/model/user_api_model.dart';
import 'package:servzz/features/auth/data/model/user_hive_model.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDatasource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final userData = await _hiveService.login(username, password);
      if (userData != null && userData.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
//   Future<LoginResponseModel> loginUser(String username, String password) async {
//   try {
//     final userData = await _hiveService.login(username, password);

//     if (userData != null && userData.password == password) {
//       // Convert Hive model to API model
//       final userModel = UserApiModel(
//         userId: userData.userId,
//         username: userData.username,
//         firstName: userData.firstName,
//         lastName: userData.lastName,
//         email: userData.email,
//         password: userData.password,
//         image: userData.image,
//         phone: userData.phone,
//       );

//       // Return token and user data
//       return LoginResponseModel(
//         success: true,
//         message: 'Login successful',
//         data: userModel,
//         token: 'local_dummy_token', // Optional: replace with actual logic
//       );
//     } else {
//       throw Exception("Invalid username or password");
//     }
//   } catch (e) {
//     throw Exception("Local login failed: $e");
//   }
// }
  

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      // Convert UserEntity to Hive model if necessary
      final userHiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}
