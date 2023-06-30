import 'package:dio/dio.dart';
import 'package:sfs_frontend/helper/dio_option.dart';
import 'package:sfs_frontend/models/chat.dart';
import 'package:sfs_frontend/services/user_state.dart';

class ChatController {
  final UserState userState;
  ChatController(this.userState);

  Future<List<ChatMessage>> getChat(int other_id) async {
    var dio = Dio(baseOptions);

    var response = await dio.post("/fileSharing/chat/",
        data: {"token": userState.token, "to_id": other_id});

    return processChatResponse(response);
  }

  List<ChatMessage> processChatResponse(Response<dynamic> response) {
    List<dynamic> t = response.data;
    List<Map<String, dynamic>> data = t.cast<Map<String, dynamic>>();
    List<ChatMessage> result = data.map((e) {
      return ChatMessage(
          fromID: e["from_user_id"],
          toID: e["to_user_id"],
          url: e["url"],
          createdAt: DateTime.parse(e["uploaded_at"]));
    }).toList();
    
    return result;
  }
}
