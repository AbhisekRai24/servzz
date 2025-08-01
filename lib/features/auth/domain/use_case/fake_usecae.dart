import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';
import 'package:servzz/features/auth/domain/repository/user_repository.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fake implementation of IUserRepository for tests
class FakeUserRepository implements IUserRepository {
  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    // Just return success without doing anything
    return Right(null);
  }

  @override
  Future<Either<Failure, String>> loginUser(String email, String password) async {
    // Return a fake token always
    return Right('fake_token_123');
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    // Return a fake image URL or name
    return Right('fake_image_name.jpg');
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    // Return a dummy user entity
  return Right(UserEntity(
  userId: '1',
  firstName: 'Test',
  lastName: 'User',
  username: 'testuser',
  password: 'password123',  // only if password is part of UserEntity
  email: 'test@example.com',
  phone: '1234567890',
  image: null,
));
  }
}

// Fake implementation of TokenSharedPrefs for tests
class FakeTokenSharedPrefs extends TokenSharedPrefs {
  String? _token;

  // Since original TokenSharedPrefs constructor requires SharedPreferences, 
  // we call super with a dummy SharedPreferences instance (or null).
  FakeTokenSharedPrefs() : super(sharedPreferences: FakeSharedPreferences());

  @override
  Future<Either<Failure, void>> saveToken(String token) async {
    _token = token;
    return Right(null);
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    return Right(_token);
  }

  @override
  Future<Either<Failure, void>> clearToken() async {
    _token = null;
    return Right(null);
  }
}

// A minimal fake SharedPreferences to satisfy TokenSharedPrefs constructor
class FakeSharedPreferences implements SharedPreferences {
  final Map<String, Object> _storage = {};

  @override
  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }

  @override
  String? getString(String key) {
    return _storage[key] as String?;
  }

  @override
  Future<bool> remove(String key) async {
    _storage.remove(key);
    return true;
  }

  // Implement other SharedPreferences methods as no-op or throw UnimplementedError

  @override
  Set<String> getKeys() {
    return _storage.keys.toSet();
  }

  @override
  Future<bool> clear() {
    _storage.clear();
    return Future.value(true);
  }

  // You can add more dummy overrides if your tests need them
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
