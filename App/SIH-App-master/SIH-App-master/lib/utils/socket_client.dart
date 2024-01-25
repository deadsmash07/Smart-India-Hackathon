import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = IO.io("http://localhost:3001",
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket!.connect().onConnect((data) => print("kk"));
    socket!.onConnectError((err) => print("error-------"+err));
    socket!.onError((err) => print("error-------"+err));
    
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
