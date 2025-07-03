import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:servzz/app/constant/hive_table_constant.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

import 'package:uuid/uuid.dart';

// dart run build_runner build -d
part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
  @HiveField(3)
  final String? image;
  @HiveField(4)
  final String? phone;
  @HiveField(5)
  final String username;
  @HiveField(6) 
  final String email;
  @HiveField(8)
  final String password;

  UserHiveModel({
    String? userId,
    required this.firstName,
    required this.lastName,
    this.image,
    this.phone,
    required this.username,
    required this.email,
    required this.password,
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const UserHiveModel.initial()
    : userId = '',
      firstName = '',
      lastName = '',
      image = '',
      phone = '',
      username = '',
      email = '',
      password = '';

  // From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      image: entity.image,
      phone: entity.phone,
      username: entity.username,
      email: entity.email,
      password: entity.password,
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      image: image,
      phone: phone,
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    image,
    username,
    email,
    password,
  ];
}
