import 'package:json_annotation/json_annotation.dart';
import 'user_api_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final bool success;
  final String message;
  final UserApiModel data;
  final String token;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
