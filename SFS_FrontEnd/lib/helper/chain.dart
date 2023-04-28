import 'package:encrypt/encrypt.dart';
import 'package:sfs_frontend/helper/aes.dart';
import 'package:sfs_frontend/helper/rsa.dart';
import 'package:sfs_frontend/helper/type.dart';
import 'package:sfs_frontend/models/data.dart';

class Chain {
  static Data encrypt(RSAPublicKey pk, Bytes data) {
    Key k = Key.fromSecureRandom(32);
    Bytes encrypted_data = AESWrapper.encrypt(data, k.bytes);
    Bytes encrypted_key = pk.encryptData(k.bytes);

    return Data(encryptedData: encrypted_data, encryptedKey: encrypted_key);
  }
  static Bytes decrypt(RSAPrivateKey pk, Data data) {
    Bytes k = pk.decryptData(data.encryptedKey);
    Bytes orig_data = AESWrapper.decrypt(data.encryptedData, k);
    return orig_data;
  }
}