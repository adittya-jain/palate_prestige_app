// ignore_for_file: avoid_print

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'dart:async';


class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

  // Stream controller for orderReady event
  final StreamController<Map<String, dynamic>> _orderReadyController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get orderReadyStream => _orderReadyController.stream;

  SocketClient._internal() {
    socket = IO.io('https://afosfr-server.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.onConnect((_) => print('Connected to server'));
    socket!.onDisconnect((_) => print('Disconnected from server'));
    socket!.onConnectError((error) => print('Connection error: $error'));
    socket!.onError((error) => print('Socket error: $error'));

    // Listen to "orderReady" event
    socket!.on('orderReady', (data) {
      print('Order is ready: $data');
      _orderReadyController.add(data); // Add event to stream
    });

    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  void sendMessage(String message, String name) {
    _socketClient.emit('sendMessage', {'message': message, 'namee': name});
  }

  void newOrder(Map<String, dynamic> orderJson) {
    _socketClient.emitWithAck(
      'newOrder',
      orderJson,
      ack: (data) {
        print(data);
      },
    );
    print(orderJson);
  }

  
}
