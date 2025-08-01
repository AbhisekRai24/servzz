import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/common/socket_service.dart';
import 'package:servzz/features/auth/presentation/view/login_view.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/home/presentation/view_model/home_state.dart';

// class HomeViewModel extends Cubit<HomeState> {
//   final LoginViewModel loginViewModel;
//   final TokenSharedPrefs _tokenSharedPrefs;

//   HomeViewModel({
//     required this.loginViewModel,
//     required TokenSharedPrefs tokenSharedPrefs,
//   }) : _tokenSharedPrefs = tokenSharedPrefs,
//        super(const HomeState(selectedIndex: 0, views: [])) {
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     final userId = await _getUserIdFromToken();

//     if (userId != null) {
//       emit(HomeState.initial(userId));
//     } else {
//       emit(
//         const HomeState(
//           selectedIndex: 0,
//           views: [Center(child: Text("Failed to load user data"))],
//         ),
//       );
//     }
//   }

//   Future<String?> _getUserIdFromToken() async {
//     final result = await _tokenSharedPrefs.getToken(); // get the JWT token

//     return result.fold(
//       (failure) {
//         print("Failed to get token: ${failure.message}");
//         return null;
//       },
//       (token) {
//         if (token == null) {
//           print("Token is null");
//           return null;
//         }
//         try {
//           final payload = Jwt.parseJwt(token);
//           final userId = payload['_id']; // decode userId from JWT
//           print("Decoded userId from token: $userId");
//           return userId;
//         } catch (e) {
//           print("Error decoding JWT token: $e");
//           return null;
//         }
//       },
//     );
//   }

//   void onTabTapped(int index) {
//     emit(state.copyWith(selectedIndex: index));
//   }
//    void initializeSocket(String userId) {
//     SocketService().initSocket(userId);
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
//               builder:
//                   (context) => BlocProvider.value(
//                     value: loginViewModel,
//                     child: const LoginView(),
//                   ),
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
       super(const HomeState(selectedIndex: 0, views: []));

  //calling externaly by homeview
  Future<void> initialize() async {
    final userId = await getUserIdFromToken();

    if (userId != null) {
      initializeSocket(userId);
      emitInitialState(userId);
    } else {
      emitErrorState();
    }
  }

  
  Future<String?> getUserIdFromToken() async {
    final result = await _tokenSharedPrefs.getToken();

    return result.fold(
      (failure) {
        print("Failed to get token: ${failure.message}");
        return null;
      },
      (token) {
        if (token == null) return null;
        try {
          final payload = Jwt.parseJwt(token);
          final userId = payload['_id'];
          return userId;
        } catch (e) {
          print("JWT decode error: $e");
          return null;
        }
      },
    );
  }

  void initializeSocket(String userId) {
    SocketService().initSocket(userId);
  }

  void emitInitialState(String userId) {
    emit(HomeState.initial(userId));
  }

  void emitErrorState() {
    emit(
      const HomeState(
        selectedIndex: 0,
        views: [Center(child: Text("Failed to load user data"))],
      ),
    );
  }

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  // clear token from local storage to return to login screen
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
                  (_) => BlocProvider.value(
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
