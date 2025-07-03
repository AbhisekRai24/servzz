import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/core/common/my_snackbar.dart';
import 'package:servzz/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:servzz/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  // final BatchViewModel _batchViewModel;
  // final CourseViewModel _courseViewModel;
  final UserRegisterUsecase _userRegisterUsecase;
  final UploadImageUsecase _uploadImageUsecase;

  RegisterViewModel(this._userRegisterUsecase, this._uploadImageUsecase)
    : super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<UploadImageEvent>(_onLoadImage);
    // on<LoadCoursesAndBatchesEvent>(_onLoadCoursesAndBatches);

    // add(LoadCoursesAndBatchesEvent());
  }

  // void _onLoadCoursesAndBatches(
  //   LoadCoursesAndBatchesEvent event,
  //   Emitter<RegisterState> emit,
  // ) {
  //   emit(state.copyWith(isLoading: true));
  //   // _batchViewModel.add(LoadBatchesEvent());
  //   // _courseViewModel.add(LoadCourseEvent());
  //   emit(state.copyWith(isLoading: false, isSuccess: true));
  // }

   Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userRegisterUsecase(
      RegisterUserParams(
        firstname: event.firstName,
        lastname: event.lastName,
        phone: event.phone,
        email: event.email,
        username: event.username,
        password: event.password,
        image: state.imageName,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
    );
  }

  void _onLoadImage(UploadImageEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _uploadImageUsecase.call(
      UploadImageParams(file: event.file),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (imageName) => emit(
          state.copyWith(isLoading: false, isSuccess: true, imageName: imageName)),
    );
  }
}