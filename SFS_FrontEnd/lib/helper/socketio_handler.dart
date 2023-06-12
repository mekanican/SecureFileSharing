import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class Socket {
  static final Socket _instance = Socket._internal();
  factory Socket() {
    return _instance;
  }

  late IO.Socket sk;

  Socket._internal() {
    sk = IO.io("http://localhost:3400", 
      IO.OptionBuilder()
      .setTransports(['websocket'])
      .build()
    );
    sk.onDisconnect((data) => print("Disconnect"));
  }
}