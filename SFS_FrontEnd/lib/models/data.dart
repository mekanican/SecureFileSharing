import 'dart:convert';

import '../helper/type.dart';

class Data {
  final Bytes encryptedData;
  final Bytes encryptedKey;
  Data({required this.encryptedData, required this.encryptedKey});

  String toBase64() {
    return base64Encode(encryptedKey + encryptedData);
  }

  static Data fromBytes(Bytes l, {int keysize = 32}) {
    return Data(
        encryptedData: l.sublist(keysize), encryptedKey: l.sublist(0, keysize));
  }
}
