import 'package:crypto/crypto.dart';
import 'package:sfs_frontend/helper/type.dart';

class MD5 {
  static String getHash(Bytes data) {
    var digest = md5.convert(data);
    return digest.toString();
  }
}
