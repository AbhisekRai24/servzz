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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.currentUser == null) {
          return const Center(child: Text('No user info found.'));
        }

        UserEntity user = state.currentUser!;

        return Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 600 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile image
                    Center(
                      child:
                          user.image != null && user.image!.isNotEmpty
                              ? CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  'http://10.0.2.2:5050/${user.image!.replaceAll('\\', '/')}',
                                ),
                                backgroundColor: Colors.grey[300],
                                onBackgroundImageError: (_, __) {},
                              )
                              : CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[700],
                                ),
                              ),
                    ),

                    const SizedBox(height: 24),

                    // Info card
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'Name',
                              '${user.firstName ?? ''} ${user.lastName ?? ''}',
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
                    const SizedBox(height: 32),

                    // 🔴 Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          showMySnackBar(
                            context: context,
                            message: 'Logging out...',
                            color: Colors.red,
                          );
                          context.read<HomeViewModel>().logout(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
            fontWeight: FontWeight.w600,
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
