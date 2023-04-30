import '../helper/type.dart';

class Data {
  final Bytes encryptedData;
  final Bytes encryptedKey;
  Data({
    required this.encryptedData,
    required this.encryptedKey
  });
}