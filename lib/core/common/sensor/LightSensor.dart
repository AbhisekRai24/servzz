import 'dart:async';
import 'package:ambient_light/ambient_light.dart';

class LightSensorService {
  final AmbientLight _light = AmbientLight();
  StreamSubscription<double>? _subscription;
  bool _simulate = false;

  /// Enable simulation mode (useful for emulator/testing)
  void enableSimulation(bool enable) {
    _simulate = enable;
    print('LightSensorService: Simulation mode set to $_simulate');
  }

  void start(Function(double lux) onLuxChange) {
    print('LightSensorService: Starting sensor...');
    if (_simulate) {
      print('LightSensorService: Running in simulation mode.');
      double lux = 5;
      Timer.periodic(Duration(seconds: 4), (timer) {
        print('LightSensorService (simulated): Current lux value = $lux');
        onLuxChange(lux);
        lux = (lux == 5) ? 150 : 5; // toggle between dark and bright
      });
    } else {
      print('LightSensorService: Listening to real sensor stream.');
      _subscription = _light.ambientLightStream.listen((lux) {
        print('LightSensorService (real): Received lux value = $lux');
        onLuxChange(lux);
      });
    }
  }

   void stop() {
    print('LightSensorService: Stopping sensor...');
    _subscription?.cancel();
  }
}