import 'dart:io';
import 'package:dio/dio.dart';
import 'package:servzz/app/constant/api_endpoints.dart';
import 'package:servzz/core/network/api_service.dart';
import 'package:servzz/features/auth/data/data_source/user_data_source.dart';
import 'package:servzz/features/auth/data/model/user_api_model.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';


class UserRemoteDataSource implements IUserDatasource {
  final ApiService _apiService;
  UserRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception('Failed to login student: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login student: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity studentData) async {
    try {
      final studentApiModel = UserApiModel.fromEntity(studentData);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: studentApiModel.toJson(),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(
          'Failed to register student: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to register student: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register student: $e');
    }
  }

  @override
Future<String> uploadProfilePicture(File file) {
  throw UnimplementedError('Upload profile picture API not implemented yet');
}

  @override
  Future<UserEntity> getCurrentUser() {
    throw UnimplementedError();
  }
}
