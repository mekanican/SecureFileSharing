

import 'package:flutter/foundation.dart';
import 'package:sfs_frontend/helper/chain.dart';
import 'package:sfs_frontend/helper/rsa.dart';
import 'package:sfs_frontend/helper/type.dart';

class Signature {
  static Bytes getSignature(Bytes data, RSAPrivateKey pk) {
    var p = pk.signData(data);
    while(p.length < Chain.keySize) {
      p.insert(0, 0);
    }
    return p;
  }

  static bool checkSignature(Bytes msg, Bytes sig, RSAPublicKey pk) {
    var p = pk.unsignData(sig);
    while(p.length < Chain.keySize) {
      p.insert(0, 0);
    }
    return listEquals(msg, p);
  }
}
