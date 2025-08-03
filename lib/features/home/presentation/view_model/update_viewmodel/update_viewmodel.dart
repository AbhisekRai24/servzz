
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/auth/domain/use_case/update_user_usecase.dart';
import 'package:servzz/features/home/presentation/view_model/update_viewmodel/update_event.dart';
import 'package:servzz/features/home/presentation/view_model/update_viewmodel/update_state.dart';

class UpdateUserViewModel extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UpdateUserUsecase _updateUserUsecase;

  UpdateUserViewModel({required UpdateUserUsecase updateUserUsecase})
    : _updateUserUsecase = updateUserUsecase,
      super(const UpdateUserState.initial()) {
    on<InitializeUserDataEvent>(_onInitializeUserData);
    on<UpdateFirstNameEvent>(_onUpdateFirstName);
    on<UpdateLastNameEvent>(_onUpdateLastName);
    on<UpdateUsernameEvent>(_onUpdateUsername);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<UpdatePhoneEvent>(_onUpdatePhone);
    on<UpdateProfileImageEvent>(_onUpdateProfileImage);
    on<SubmitUpdateUserEvent>(_onSubmitUpdateUser);
    on<ResetUpdateUserStateEvent>(_onResetUpdateUserState);
  }

  void _onInitializeUserData(
    InitializeUserDataEvent event,
    Emitter<UpdateUserState> emit,
  ) {
    emit(
      state.copyWith(
        firstName: event.user.firstName ?? '',
        lastName: event.user.lastName ?? '',
        username: event.user.username ?? '',
        email: event.user.email ?? '',
        phone: event.user.phone ?? '',
        selectedImage: null,
        isLoading: false,
        isSuccess: false,
        hasError: false,
        error: null,
      ),
    );
  }

  void _onUpdateFirstName(
    UpdateFirstNameEvent event,
    Emitter<UpdateUserState> emit,
  ) {
    emit(
      state.copyWith(firstName: event.firstName, hasError: false, error: null),
    );
  }

  void _onUpdateLastName(
    UpdateLastNameEvent event,
    Emitter<UpdateUserState> emit,
  ) {
    emit(
      state.copyWith(lastName: event.lastName, hasError: false, error: null),
    );
  }

  void _onUpdateUsername(
    UpdateUsernameEvent event,
    Emitter<UpdateUserState> emit,
  ) {
    emit(
      state.copyWith(username: event.username, hasError: false, error: null),
    );
  }

  void _onUpdateEmail(UpdateEmailEvent event, Emitter<UpdateUserState> emit) {
    emit(state.copyWith(email: event.email, hasError: false, error: null));
  }

  void _onUpdatePhone(UpdatePhoneEvent event, Emitter<UpdateUserState> emit) {
    emit(state.copyWith(phone: event.phone, hasError: false, error: null));
  }

  void _onUpdateProfileImage(
    UpdateProfileImageEvent event,
    Emitter<UpdateUserState> emit,
  ) {
    emit(
      state.copyWith(selectedImage: event.image, hasError: false, error: null),
    );
  }

  void _onSubmitUpdateUser(
    SubmitUpdateUserEvent event,
    Emitter<UpdateUserState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        hasError: false,
        error: null,
      ),
    );

    try {
      final params = UpdateUserParams(
        userData: event.userData,
        profileImage: event.profileImage,
      );

      final result = await _updateUserUsecase.call(params);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: false,
              hasError: true,
              error: failure.message,
            ),
          );
        },
        (updatedUser) {
          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              hasError: false,
              error: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          hasError: true,
          error: 'Unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  void _onResetUpdateUserState(
    ResetUpdateUserStateEvent event,
    Emitter<UpdateUserState> emit,
  ) {
    emit(const UpdateUserState.initial());
  }
}