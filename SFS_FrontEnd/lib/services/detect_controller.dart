import 'package:dio/dio.dart';
import 'package:sfs_frontend/helper/dio_option.dart';

class DetectController {
  DetectController();
  Future<bool> detect(String hash) async {
    var dio = Dio(baseOptions2);

    var response = await dio.post("/malware", data: {
      "hash": hash
    });

    Map<String, dynamic> data = response.data;
    String result = data.cast<String, String>()["result"]!;
    if (result == "malware") {
      return true;
    } else {
      return false;
    }
  }
}
