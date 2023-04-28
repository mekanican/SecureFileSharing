import 'package:sfs_frontend/helper/type.dart';

class RSAPublicKey {
  final BigInt n;
  final BigInt e;

  RSAPublicKey({
    required this.n,
    required this.e
  });

  Bytes encryptData(Bytes data) {
    BigInt message = readBytes(data);
    return writeBigInt(message.modPow(e, n));
  }
}

class RSAPrivateKey {
  final BigInt p;
  final BigInt q;
  final BigInt d;

  RSAPrivateKey({
    required this.p,
    required this.q,
    required this.d
  });

  Bytes decryptData(Bytes data) {
    BigInt enc = readBytes(data);
    BigInt n = p * q;
    return writeBigInt(enc.modPow(d, n));
  }
}