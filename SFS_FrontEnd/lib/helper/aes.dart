import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:sfs_frontend/helper/type.dart';

class AESWrapper {
  static Bytes encrypt(Bytes data, Bytes key) {
    final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(utf8.decode(data));
    return encrypted.bytes;
  }

  static Bytes decrypt(Bytes enc, Bytes key) {
    final decrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
    final data = decrypter.decrypt(Encrypted(enc));
    return Bytes.fromList(utf8.encode(data));
  }

}