// lib/app/services/socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;

  factory SocketService() => _instance;

  SocketService._internal();

  void initSocket(String userId) {
    socket = IO.io(
      'http://10.0.2.2:5050',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('🔌 Connected to Socket.IO');
      socket.emit('join', userId);
    });

    socket.on('orderStatusUpdated', (data) {
      print('📦 Order update: $data');
      // You can show a toast or trigger Bloc here
    });

    socket.onDisconnect((_) => print('❌ Disconnected from Socket.IO'));
  }

  void dispose() {
    socket.dispose();
  }
}
