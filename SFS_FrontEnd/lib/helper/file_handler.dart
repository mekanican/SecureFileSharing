import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sfs_frontend/helper/rsa.dart';
import 'package:sfs_frontend/helper/type.dart';

Future<String> get _localPath async {
  final directory = await getApplicationSupportDirectory();
  return directory.path;
}

const String pubkeyName = "/key.pub";
const String privkeyName = "/key.priv";

Future<bool> checkExistKeyPair(int id) async {
  final base = await _localPath;
  var a = File("$base$pubkeyName.$id");
  var b = File("$base$privkeyName.$id");

  return await a.exists() && await b.exists();
}

Future<RSAPublicKey> getPubKey(int id) async {
  final base = await _localPath;
  var a = File("$base$pubkeyName.$id");

  var data = await a.readAsString();
  Map<String, dynamic> json = jsonDecode(data);
  return RSAPublicKey.fromJSON(json.cast<String, String>());
}

Future<RSAPrivateKey> getPrivKey(int id) async {
  final base = await _localPath;
  var a = File("$base$privkeyName.$id");
  var data = await a.readAsString();
  Map<String, dynamic> json = jsonDecode(data);
  return RSAPrivateKey.fromJSON(json.cast<String, String>());
}

void setPubKey(RSAPublicKey p, int id) async {
  final base = await _localPath;
  print(base);
  var a = File("$base$pubkeyName.$id");

  var data = jsonEncode(p.toJson());
  a.writeAsString(data);
}

void setPrivKey(RSAPrivateKey p, int id) async {
  final base = await _localPath;
  var a = File("$base$privkeyName.$id");

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

Future<Bytes> openFile(String filename) async {
  var base = await _localPath;
  var a = File("$base/$filename");
  return a.readAsBytes();
}