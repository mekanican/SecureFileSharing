import 'dart:math';
import 'package:sfs_frontend/models/friend.dart';

// Note that we should use WebHook for receive incoming event
// if you want to change to pooling, contact me instead
class FriendController {
  // Example list of friends

  final _friendPerPage = 3;

  Future<int> getNumberOfFriend() async {
    return Future.delayed(Duration(seconds: 1), () {
      // Example code to fetch IC
      return 4;
    });
    ;
  }

  Future<List<Friend>> fetchPage(int pageKey) async {
    List<Friend> friends = [];
    try {
      friends = await getFriends(startAt: pageKey, pageSize: _friendPerPage);
      print("friends result: $friends");
      print("pageKey: $pageKey");

      List<Friend> temp = [...friends];
      friends.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
      friends.forEach((element) {
        temp.removeWhere((elementQuery) => elementQuery.name == element.name);
      });

      temp.insertAll(0, friends);

      return temp;
    } catch (error) {
      return friends;
    }
  }

  Future<List<Friend>> getFriends({startAt, pageSize}) async {
    List<Friend> _friends = [
      new Friend(id: '1', name: 'Alice', lastMessageAt: DateTime.now()),
      new Friend(id: '2', name: 'Get', lastMessageAt: DateTime.now()),
      new Friend(id: '3', name: 'Duck', lastMessageAt: DateTime.now()),
      new Friend(id: '4', name: 'Help', lastMessageAt: DateTime.now()),
    ];
    // Example code to fetch friends from the server
    return Future.delayed(Duration(seconds: 1), () {
      int initValue = startAt * pageSize;
      print(initValue);
      return _friends.skip(initValue).take(pageSize).toList();
    });
  }

  Future<String> generateCode() async {
    // Example code to fetch friends from code gểnate
    return await Future.delayed(Duration(seconds: 1), () {
      return 'CuAJSTnT${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  Future<String> addInviteCode(String ic) async {
    return Future.delayed(Duration(seconds: 1), () {
      // Example code to add Invite Code
      return "Success";
    });
  }

  Future<String> addIC(String ic) async {
    try {
      String flag = await addInviteCode(ic);
      if (flag == "Success") {
        return "Add IC success";
      } else {
        return "Add IC failed";
      }
    } catch (error) {
      return error.toString();
    }
  }
}
