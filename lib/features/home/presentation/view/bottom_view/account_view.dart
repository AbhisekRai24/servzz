import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:servzz/common/my_snack_bar.dart';
import 'package:servzz/features/auth/domain/entity/user_entity.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:servzz/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:servzz/features/home/presentation/view_model/home_view_model.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.now();
  final double shakeThreshold = 10.0;
  final Duration shakeCooldown = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _startListeningToShake();

    // Trigger fetching current user on load
    context.read<LoginViewModel>().add(FetchCurrentUserEvent(context: context));
  }

  void _startListeningToShake() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > shakeThreshold &&
          DateTime.now().difference(_lastShakeTime) > shakeCooldown) {
        _lastShakeTime = DateTime.now();

        showMySnackBar(
          context: context,
          message: 'Shake detected! Logging out...',
          color: Colors.red,
        );

        context.read<HomeViewModel>().logout(context);
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.currentUser == null) {
          return const Center(child: Text('No user info found.'));
        }

        UserEntity user = state.currentUser!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                if (user.image != null && user.image!.isNotEmpty)
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(
                      'http://10.0.2.2:5050/' +
                          user.image!.replaceAll('\\', '/'),
                    ),
                    onBackgroundImageError: (_, __) {},
                  )
                else
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[700],
                    ),
                  ),

                const SizedBox(height: 24),

                // User Info Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Name',
                          '${user.firstName} ${user.lastName}',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Email', user.email ?? 'N/A'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Username', user.username ?? 'N/A'),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Phone',
                          (user.phone == null || user.phone!.trim().isEmpty)
                              ? 'Unregistered'
                              : user.phone!,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Role', user.role ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
