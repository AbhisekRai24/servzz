import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';

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
      final fullMessage = data['message'] ?? 'Order status updated';

      // Use RegExp to find order ID after #
      final regex = RegExp(r'#([a-fA-F0-9]{5,})');
      final match = regex.firstMatch(fullMessage);

      String displayMessage = fullMessage;

      if (match != null && match.groupCount >= 1) {
        final fullOrderId = match.group(1)!;
        final shortOrderId =
            fullOrderId.length > 5
                ? fullOrderId.substring(fullOrderId.length - 5)
                : fullOrderId;

        // Replace full order id with shortened one in message
        displayMessage = fullMessage.replaceFirst(regex, '#$shortOrderId');
      }

      showSimpleNotification(
        Text(displayMessage),
        background: Colors.green.shade700,
        duration: const Duration(seconds: 3),
      );
    });

    socket.onDisconnect((_) => print('❌ Disconnected from Socket.IO'));
  }

  void dispose() {
    socket.dispose();
  }
}
