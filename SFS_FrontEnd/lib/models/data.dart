import 'dart:convert';

import 'package:sfs_frontend/helper/chain.dart';

import '../helper/type.dart';

class Data {
  final Bytes encryptedData;
  final Bytes encryptedKey;
  Data({required this.encryptedData, required this.encryptedKey});

  String toBase64() {
    return base64Encode(encryptedKey + encryptedData);
  }

  static Data fromBytes(Bytes l) {
    return Data(
        encryptedData: l.sublist(Chain.keySize), encryptedKey: l.sublist(0, Chain.keySize));
  }
}
