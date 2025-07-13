

import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

class MockFile extends Mock implements File {}

void main() {
  late MockUserRegisterUsecase mockUserRegisterUsecase;
  late MockUploadImageUsecase mockUploadImageUsecase;

  setUp(() {
    mockUserRegisterUsecase = MockUserRegisterUsecase();
    mockUploadImageUsecase = MockUploadImageUsecase();

    registerFallbackValue(
      RegisterUserParams(
        firstname: '',
        lastname: '',
        phone: '',
        username: '',
        email: '',
        password: '',
        image: '',
      ),
    );

    registerFallbackValue(UploadImageParams(file: MockFile()));
  });

  group('RegisterViewModel Tests', () {
    test('initial state is RegisterState.initial()', () {
      final registerViewModel = RegisterViewModel(
        mockUserRegisterUsecase,
        mockUploadImageUsecase,
      );
      expect(registerViewModel.state, RegisterState.initial());
    });

    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, success with imageName] when image upload succeeds',
      build: () {
        when(
          () => mockUploadImageUsecase.call(any()),
        ).thenAnswer((_) async => const Right('uploaded.jpg'));
        return RegisterViewModel(
          mockUserRegisterUsecase,
          mockUploadImageUsecase,
        );
      },
      act: (bloc) => bloc.add(UploadImageEvent(file: MockFile())),
      expect:
          () => [
            const RegisterState(isLoading: true, isSuccess: false),
            const RegisterState(
              isLoading: false,
              isSuccess: true,
              imageName: 'uploaded.jpg',
            ),
          ],
    );
