import 'dart:io';
import 'package:flutter/material.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';

abstract class UpdateUserEvent {}

class InitializeUserDataEvent extends UpdateUserEvent {
  final UserEntity user;

  InitializeUserDataEvent(this.user);
}

class UpdateFirstNameEvent extends UpdateUserEvent {
  final String firstName;

  UpdateFirstNameEvent(this.firstName);
}

class UpdateLastNameEvent extends UpdateUserEvent {
  final String lastName;

  UpdateLastNameEvent(this.lastName);
}

class UpdateUsernameEvent extends UpdateUserEvent {
  final String username;

  UpdateUsernameEvent(this.username);
}

class UpdateEmailEvent extends UpdateUserEvent {
  final String email;

  UpdateEmailEvent(this.email);
}

class UpdatePhoneEvent extends UpdateUserEvent {
  final String phone;

  UpdatePhoneEvent(this.phone);
}

class UpdateProfileImageEvent extends UpdateUserEvent {
  final File image;

  UpdateProfileImageEvent(this.image);
}

class SubmitUpdateUserEvent extends UpdateUserEvent {
  final UserEntity userData;
  final File? profileImage;
  final BuildContext context;

  SubmitUpdateUserEvent({
    required this.userData,
    this.profileImage,
    required this.context,
  });
}

class ResetUpdateUserStateEvent extends UpdateUserEvent {}