import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sfs_frontend/helper/dio_option.dart';
import 'package:sfs_frontend/models/friend_clone.dart';
import 'package:sfs_frontend/services/user_state.dart';

class FriendController {
  final UserState userState;
  FriendController(this.userState);

  Future<List<Friend>> getListFriend() async {
    var dio = Dio(baseOptions);

    var response = await dio
        .post("/fileSharing/friend/", data: {'token': userState.token});
    List<dynamic> t = response.data;
    List<Map<String, dynamic>> data = t.cast<Map<String, dynamic>>();
    List<Friend> result = data.map((e) {
      return Friend(
        id: e["friend_id"],
        name: e["username"],
        lastMessageAt:
            e["uploaded_at"] == "" ? null : DateTime.parse(e["uploaded_at"]),
      );
    }).toList();

    return result;
  }

  Future<String> getCode() async {
    var dio = Dio(baseOptions);

    var response =
        await dio.post("/friend/get/", data: {'token': userState.token});

    dynamic responseData = response.data;
    return responseData["friend_code"];
  }

  Future<String> generateCode() async {
    var dio = Dio(baseOptions);

    var response =
        await dio.post("/friend/generate/", data: {'token': userState.token});

    dynamic responseData = response.data;
    return responseData["friend_code"];
  }

  Future<String> addInviteCode(String ic) async {
    var dio = Dio(baseOptions);

    var response = await dio.post("/friend/add/",
        data: {'token': userState.token, 'friend_code': ic});
    dynamic responseData = response.data;
    return responseData["messages"];
  }

  Future<String> addIC(String ic) async {
    try {
      String flag = await addInviteCode(ic);
      return flag;
    } catch (error) {
      return error.toString();
    }
  }
}
