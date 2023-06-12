import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sfs_frontend/helper/rsa.dart';

Future<String> get _localPath async {
  final directory = await getApplicationSupportDirectory();
  return directory.path;
}

const String pubkeyName = "/key.pub";
const String privkeyName = "/key.priv";

Future<bool> checkExistKeyPair() async {
  final base = await _localPath;
  var a = File(base + pubkeyName);
  var b = File(base + privkeyName);

  return await a.exists() && await b.exists();
}

Future<RSAPublicKey> getPubKey() async {
  final base = await _localPath;
  var a = File(base + pubkeyName);

  var data = await a.readAsString();
  Map<String, String> json = jsonDecode(data);
  return RSAPublicKey.fromJSON(json);
}

Future<RSAPrivateKey> getPrivKey() async {
  final base = await _localPath;
  var a = File(base + privkeyName);
  var data = await a.readAsString();
  Map<String, String> json = jsonDecode(data);
  return RSAPrivateKey.fromJSON(json);
}

void setPubKey(RSAPublicKey p) async {
  final base = await _localPath;
  print(base);
  var a = File(base + pubkeyName);

  var data = jsonEncode(p.toJson());
  a.writeAsString(data);
}

void setPrivKey(RSAPrivateKey p) async {
  final base = await _localPath;
  var a = File(base + privkeyName);

  var data = jsonEncode(p.toJson());
  a.writeAsString(data);
}




Future<void> downloadFile(String url, String filename) async {
  var base = await _localPath;
  // Create a Dio instance
  var dio = Dio();

  // Start the download
  try {
    await dio.download(url, "$base/$filename");
    print('Download complete!');
  } catch (e) {
    print('Error downloading file: $e');
  }
}