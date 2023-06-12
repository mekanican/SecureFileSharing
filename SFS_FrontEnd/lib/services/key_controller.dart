import 'package:dio/dio.dart';
import 'package:sfs_frontend/helper/dio_option.dart';
import 'package:sfs_frontend/helper/rsa.dart';
import 'package:sfs_frontend/helper/type.dart';
import 'package:sfs_frontend/services/user_state.dart';

class KeyController {
  final UserState userState;
  KeyController(this.userState);

  Future<Pair<RSAPublicKey, RSAPrivateKey>> getKeyPair() async {
    var dio = Dio(baseOptions);
    var token = userState.token;
    var response = await dio.get("/keys/generate?token=$token");
    Map<String, dynamic> data = response.data;
    Map<String, dynamic> keys = data["keys"];
    Map<String, dynamic> pubkey = keys["public"];
    Map<String, dynamic> privkey = keys["private"];


    return Pair(
      RSAPublicKey.fromJSON(pubkey.cast<String, String>()),
      RSAPrivateKey.fromJSON(privkey.cast<String, String>()),
    );
  }

  Future<RSAPublicKey> getOtherPubKey(int user_id) async {
    var dio = Dio(baseOptions);
    var token = userState.token;

    var response = await dio.get("/keys/get?token=$token&id=$user_id");
    Map<String, dynamic> data = response.data;
    Map<String, dynamic> pubkey = data["public_key"];
    return RSAPublicKey.fromJSON(pubkey.cast<String, String>());
  }
}