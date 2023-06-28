import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Socket {
  static final Socket _instance = Socket._internal();
  factory Socket() {
    return _instance;
  }

  late IO.Socket sk;

  Socket._internal() {
    sk = IO.io(dotenv.env['SOCKET_URL'] ?? "http://localhost:3400",
        IO.OptionBuilder().setTransports(['websocket']).build());
    sk.onConnectError((data) => print(data.toString()));
    sk.onDisconnect((data) => print("Disconnect"));
  }
}
