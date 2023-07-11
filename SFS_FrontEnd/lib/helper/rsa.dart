import 'package:sfs_frontend/helper/type.dart';

class RSAPublicKey {
  final BigInt n;
  final BigInt e;

  RSAPublicKey({required this.n, required this.e});

  Bytes encryptData(Bytes data) {
    BigInt message = readBytes(data);
    return writeBigInt(message.modPow(e, n));
  }

  //  Same functionality but for another purpose!
  Bytes unsignData(Bytes data) {
    BigInt enc = readBytes(data);
    return writeBigInt(enc.modPow(e, n));
  }

  RSAPublicKey.fromJSON(Map<String, String> json)
      : n = BigInt.parse(json["n"]!),
        e = BigInt.parse(json["e"]!);

  Map<String, String> toJson() => {
        'n': n.toString(),
        'e': e.toString(),
      };
}

class RSAPrivateKey {
  final BigInt p;
  final BigInt q;
  final BigInt d;

  RSAPrivateKey({required this.p, required this.q, required this.d});

  Bytes decryptData(Bytes data) {
    BigInt enc = readBytes(data);
    BigInt n = p * q;
    return writeBigInt(enc.modPow(d, n));
  }

  //  Same functionality but for another purpose!
  Bytes signData(Bytes data) {
    BigInt enc = readBytes(data);
    BigInt n = p * q;
    return writeBigInt(enc.modPow(d, n));
  }

  RSAPrivateKey.fromJSON(Map<String, String> json)
      : p = BigInt.parse(json["p"]!),
        q = BigInt.parse(json["q"]!),
        d = BigInt.parse(json["d"]!);

  Map<String, String> toJson() => {
        'p': p.toString(),
        'q': q.toString(),
        'd': d.toString(),
      };
}
