import 'package:encrypt/encrypt.dart';
import 'package:sfs_frontend/helper/type.dart';

class AESWrapper {
  static Bytes encrypt(Bytes data, Bytes key) {
    final encrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
    final iv = IV.fromLength(16);
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    return encrypted.bytes;
  }

  static Bytes decrypt(Bytes enc, Bytes key) {
    final decrypter = Encrypter(AES(Key(key), mode: AESMode.cbc));
    final iv = IV.fromLength(16);
    final data = decrypter.decryptBytes(Encrypted(enc), iv: iv);
    return Bytes.fromList(data);
  }
}
