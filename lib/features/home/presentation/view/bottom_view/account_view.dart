import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class AccountView extends StatelessWidget {
//   const AccountView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: Center(
//         child: Text(
//           'Account View',
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:servzz/common/my_snack_bar.dart';
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
    return SizedBox.expand(
      child: Center(
        child: Text(
          'Account View',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
