import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String? firstName;
  final String? lastName;
  @JsonKey(name: 'profileImage')
  final String? image;
  final String? phone;
  final String? username;
  final String? email;
  final String? password;

  const UserApiModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.image,
    this.phone,
    required this.username,
    this.email,
    this.password,
  });

  // JSON serialization
  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  // Convert from Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
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

  // Convert to Entity
  // UserEntity toEntity() {
  //   return UserEntity(
  //     userId: userId,
  //     firstName: firstName,
  //     lastName: lastName,
  //     image: image,
  //     phone: phone,
  //     username: username,
  //     email: email,
  //     password: password,
  //   );
  // }
  UserEntity toEntity() {
    return UserEntity(
      userId: userId ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      image: image ?? '',
      phone: phone ?? '',
      username: username ?? '',
      email: email ?? '',
      password: password ?? '',
    );
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    image,
    phone,
    username,
    email,
    password,
  ];
}
