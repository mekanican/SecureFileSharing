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

    Bytes encryptedData = AESWrapper.encrypt(data, k.bytes);
    Bytes encryptedKey = pk.encryptData(k.bytes);

    return Data(encryptedData: encryptedData, encryptedKey: encryptedKey);
  }

  static Bytes decrypt(RSAPrivateKey pk, Data data) {
    var k = pk.decryptData(data.encryptedKey).toList();
    while (k.length < 32) {
      k.insert(0, 0);
    }
    Bytes origData = AESWrapper.decrypt(data.encryptedData, Bytes.fromList(k));
    return origData;
  }
}
