import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/features/auth/presentation/view/login_view.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/home/presentation/view_model/home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  final LoginViewModel loginViewModel;
  final TokenSharedPrefs _tokenSharedPrefs;

  HomeViewModel({
    required this.loginViewModel,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _tokenSharedPrefs = tokenSharedPrefs,
       super(HomeState.initial());

  // ... other methods ...

  void onTabTapped(int index) {
    print("Tapped index: $index");
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) async {
    final result = await _tokenSharedPrefs.clearToken();

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${failure.message}')),
        );
      },
      (_) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: loginViewModel,
                    child: const LoginView(),
                  ),
            ),
          );
        }
      },
    );
  }
}
