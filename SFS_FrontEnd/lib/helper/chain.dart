import 'dart:ffi';

import 'package:encrypt/encrypt.dart';
import 'package:sfs_frontend/helper/aes.dart';
import 'package:sfs_frontend/helper/rsa.dart';
import 'package:sfs_frontend/helper/type.dart';
import 'package:sfs_frontend/models/data.dart';

class Chain {
  static Data encrypt(RSAPublicKey pk, Bytes data) {
    Bytes s = SecureRandom(32).bytes;
    s[0] = 0;
    Key k = Key(s);
    
    Bytes encrypted_data = AESWrapper.encrypt(data, k.bytes);
    Bytes encrypted_key = pk.encryptData(k.bytes);

    return Data(encryptedData: encrypted_data, encryptedKey: encrypted_key);
  }
  static Bytes decrypt(RSAPrivateKey pk, Data data) {
    var k = pk.decryptData(data.encryptedKey).toList();
    while (k.length < 32) {
      k.insert(0, 0);
    }
    Bytes orig_data = AESWrapper.decrypt(data.encryptedData, Bytes.fromList(k));
    return orig_data;
  }
}