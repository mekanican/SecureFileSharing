import 'dart:typed_data';

typedef Bytes = Uint8List;

// https://github.com/dart-lang/sdk/issues/32803#issuecomment-1228291047
BigInt readBytes(Bytes bytes) {
  BigInt result = BigInt.zero;

  for (final byte in bytes) {
    // reading in big-endian, so we essentially concat the new byte to the end
    result = (result << 8) | BigInt.from(byte & 0xff);
  }
  return result;
}

Bytes writeBigInt(BigInt number) {
  // Not handling negative numbers. Decide how you want to do that.
  int bytes = (number.bitLength + 7) >> 3;
  var b256 = BigInt.from(256);
  var result = Bytes(bytes);
  for (int i = 0; i < bytes; i++) {
    result[bytes - 1 - i] = number.remainder(b256).toInt();
    number = number >> 8;
  }
  return result;
}

class Pair<T1, T2> {
  final T1 fs;
  final T2 nd;
  Pair(this.fs, this.nd);
}
