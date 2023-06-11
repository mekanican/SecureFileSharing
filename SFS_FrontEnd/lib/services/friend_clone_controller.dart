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

    var response = await dio.post("/fileSharing/friend/", data: {
      'token': userState.token
    });
    List<dynamic> t = response.data;
    List<Map<String, dynamic>> data = t.cast<Map<String, dynamic>>();
    List<Friend> result = data.map((e) {
      return Friend(id: e["friend_id"], 
        name: e["username"], 
        lastMessageAt: DateTime.parse(e["uploaded_at"]),
      );
    }).toList();
    return result;
  }
}