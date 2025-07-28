import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:servzz/app/constant/api_endpoints.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/core/network/api_service.dart';
import 'package:servzz/features/auth/data/data_source/user_data_source.dart';
import 'package:servzz/features/auth/data/model/user_api_model.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDatasource {
  final ApiService _apiService;
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;
  UserRemoteDataSource({
    required ApiService apiService,
    required Dio dio,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _apiService = apiService,
       _dio = dio,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
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
  // Future<UserEntity> getCurrentUser() async {
  //   final tokenResult = await _tokenSharedPrefs.getToken();
  //   final token = tokenResult.fold(
  //     (failure) => throw Exception(failure.message),
  //     (token) => token,
  //   );
  //   final userIdResult = await _tokenSharedPrefs.getUserId();
  //   final userId = userIdResult.fold(
  //     (failure) => throw Exception(failure.message),
  //     (id) => id,
  //   );
  //   final url = '${ApiEndpoints.baseUrl}auth/$userId';
  //   try {
  //     final response = await _dio.get(
  //       url,
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //     );
  //     if (response.statusCode == 200) {
  //       return UserApiModel.fromJson(response.data['data']).toEntity();
  //     } else {
  //       throw Exception('Failed to load user info: ${response.statusMessage}');
  //     }
  //   } on DioError catch (e) {
  //     // This will trigger your interceptor, but also you can handle here
  //     print('Caught DioError in getCurrentUser: ${e.message}');
  //     if (e.response != null) {
  //       print('Status Code: ${e.response?.statusCode}');
  //       print('Response Data: ${e.response?.data}');
  //     }
  //     throw Exception('Failed to load user info due to network error.');
  //   } catch (e) {
  //     print('Unexpected error in getCurrentUser: $e');
  //     throw Exception('Unexpected error: $e');
  //   }
  // }
  @override
  @override
  Future<UserEntity> getCurrentUser() async {
    // Step 1: Get token from shared prefs
    final tokenResult = await _tokenSharedPrefs.getToken();
    final token = tokenResult.fold(
      (failure) => throw Exception(failure.message),
      (token) => token,
    );

    print('Retrieved token: $token');

    if (token == null || token.isEmpty) {
      throw Exception('No valid token found');
    }

    Map<String, dynamic> payload = Jwt.parseJwt(token);
    print('Decoded payload: $payload');

    final dynamic rawId = payload['_id'];
    if (rawId == null || rawId is! String) {
      throw Exception('User ID not found or invalid in token payload');
    }

    final userId = rawId;

    final url = '${ApiEndpoints.baseUrl}auth/$userId';

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return UserApiModel.fromJson(response.data['data']).toEntity();
      } else {
        throw Exception('Failed to load user info: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      print('Caught DioError in getCurrentUser: ${e.message}');
      if (e.response != null) {
        print('Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
      }
      throw Exception('Failed to load user info due to network error.');
    } catch (e) {
      print('Unexpected error in getCurrentUser: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // Future<LoginResponseModel> loginUser(String email, String password) async {
  //   try {
  //     final response = await _apiService.dio.post(
  //       ApiEndpoints.login,
  //       data: {'email': email, 'password': password},
  //     );
  //     if (response.statusCode == 200) {
  //       return LoginResponseModel.fromJson(response.data);
  //     } else {
  //       throw Exception(response.statusMessage);
  //     }
  //   } on DioException catch (e) {
  //     throw Exception('Failed to login user: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Failed to login user: $e');
  //   }
  // }

  @override
  Future<void> registerUser(UserEntity studentData) async {
    try {
      final studentApiModel = UserApiModel.fromEntity(studentData);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: studentApiModel.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
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
}
