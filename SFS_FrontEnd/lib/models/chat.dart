import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatMessage {
  final int fromID;
  final int toID;
  final String url;
  final DateTime createdAt;

  ChatMessage({
    required this.fromID,
    required this.toID,
    required this.url,
    required this.createdAt,
  });

  String _url2filename() {
    // https://stackoverflow.com/a/56258202
    RegExp r = RegExp(r"(?<=\/)[^\/\?#]+(?=[^\/]*$)");
    RegExpMatch? match = r.firstMatch(url);
    return match![0]!;
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  types.FileMessage toFileMessage() {
    return types.FileMessage(
        author: types.User(id: fromID.toString()),
        id: randomString(),
        name: _url2filename(),
        size: 1234,
        uri: url);
  }
}
