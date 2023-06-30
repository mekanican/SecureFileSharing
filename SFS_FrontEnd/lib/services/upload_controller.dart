import 'package:dio/dio.dart';
import 'package:sfs_frontend/helper/dio_option.dart';
import 'package:sfs_frontend/services/user_state.dart';

class UploadController {
  final UserState userState;
  UploadController(this.userState);

  Future<void> upload(int otherID, String filename, String b64data,
      {int timeToLive = 7}) async {
    var dio = Dio(baseOptions);

    await dio.post("/fileSharing/upload/", data: {
      "token": userState.token,
      "to": otherID,
      "filename": filename,
      "myfile": b64data,
      "ttl": timeToLive
    });
  }
}
