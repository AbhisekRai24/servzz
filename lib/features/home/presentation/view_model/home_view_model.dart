import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/features/auth/presentation/view/login_view.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/home/presentation/view_model/home_state.dart';

// class HomeViewModel extends Cubit<HomeState> {
//   final LoginViewModel loginViewModel;
//   final TokenSharedPrefs _tokenSharedPrefs;

//   HomeViewModel({
//     required this.loginViewModel,
//     required TokenSharedPrefs tokenSharedPrefs,
//   })  : _tokenSharedPrefs = tokenSharedPrefs,
//         super(const HomeState(selectedIndex: 0, views: [])) {
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     final userId = await _getUserId();
//     if (userId != null) {
//       emit(HomeState.initial(userId));
//     } else {
//       // fallback view or error state
//       emit(const HomeState(
//         selectedIndex: 0,
//         views: [
//           Center(child: Text("Failed to load user data")),
//         ],
//       ));
//     }
//   }

//   Future<String?> _getUserId() async {
//     final result = await _tokenSharedPrefs.getUserId();

//     return result.fold(
//       (failure) {
//         print("Failed to get userId: ${failure.message}");
//         return null;
//       },
//       (userId) => userId,
//     );
//   }

//   void onTabTapped(int index) {
//     print("Tapped index: $index");
//     emit(state.copyWith(selectedIndex: index));
//   }

//   void logout(BuildContext context) async {
//     final result = await _tokenSharedPrefs.clearToken();

//     result.fold(
//       (failure) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Logout failed: ${failure.message}')),
//         );
//       },
//       (_) {
//         if (context.mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BlocProvider.value(
//                 value: loginViewModel,
//                 child: const LoginView(),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

class HomeViewModel extends Cubit<HomeState> {
  final LoginViewModel loginViewModel;
  final TokenSharedPrefs _tokenSharedPrefs;

  HomeViewModel({
    required this.loginViewModel,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _tokenSharedPrefs = tokenSharedPrefs,
       super(const HomeState(selectedIndex: 0, views: [])) {
    _initialize();
  }

  Future<void> _initialize() async {
    final userId = await _getUserIdFromToken();

    if (userId != null) {
      emit(HomeState.initial(userId));
    } else {
      emit(
        const HomeState(
          selectedIndex: 0,
          views: [Center(child: Text("Failed to load user data"))],
        ),
      );
    }
  }

  Future<String?> _getUserIdFromToken() async {
    final result = await _tokenSharedPrefs.getToken(); // get the JWT token

    return result.fold(
      (failure) {
        print("Failed to get token: ${failure.message}");
        return null;
      },
      (token) {
        if (token == null) {
          print("Token is null");
          return null;
        }
        try {
          final payload = Jwt.parseJwt(token);
          final userId = payload['_id']; // decode userId from JWT
          print("Decoded userId from token: $userId");
          return userId;
        } catch (e) {
          print("Error decoding JWT token: $e");
          return null;
        }
      },
    );
  }

  void onTabTapped(int index) {
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
