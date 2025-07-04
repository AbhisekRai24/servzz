import 'package:equatable/equatable.dart';
// import 'package:student_management/features/batch/domain/entity/batch_entity.dart';
// import 'package:student_management/features/course/domain/entity/course_entity.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String firstName;
  final String lastName;
  final String? image;
  final String? phone;
  final String username;
  final String email;
  final String password;

  const UserEntity({
    this.userId,
    required this.firstName,
    required this.lastName,
    this.image,
    this.phone,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    image,
    phone,
    username,
    password,
  ];
}
