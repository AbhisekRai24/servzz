import 'dart:io';
import 'package:equatable/equatable.dart';

class UpdateUserState extends Equatable {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final File? selectedImage;
  final bool isLoading;
  final bool isSuccess;
  final bool hasError;
  final String? error;

  const UpdateUserState({
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.email = '',
    this.phone = '',
    this.selectedImage,
    this.isLoading = false,
    this.isSuccess = false,
    this.hasError = false,
    this.error,
  });

  const UpdateUserState.initial() : this();

  UpdateUserState copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    File? selectedImage,
    bool? isLoading,
    bool? isSuccess,
    bool? hasError,
    String? error,
  }) {
    return UpdateUserState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      selectedImage: selectedImage ?? this.selectedImage,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        username,
        email,
        phone,
        selectedImage,
        isLoading,
        isSuccess,
        hasError,
        error,
      ];
}