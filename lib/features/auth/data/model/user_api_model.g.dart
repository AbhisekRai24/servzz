// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      userId: json['_id'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      image: json['image'] as String?,
      phone: json['phone'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
      'phone': instance.phone,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };
