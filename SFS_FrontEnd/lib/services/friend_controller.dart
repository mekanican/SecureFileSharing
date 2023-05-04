import 'dart:math';
import 'package:sfs_frontend/models/friend.dart';
import 'package:sfs_frontend/services/friend_state.dart';

// Note that we should use WebHook for receive incoming event
// if you want to change to pooling, contact me instead
class FriendController {
  // Example list of friends
  final FriendState friendState;
  FriendController(this.friendState);
  final _friendPerPage = 3;

  Future<int> getNumberOfFriend() async {
    return Future.delayed(Duration(seconds: 1), () {
      // Example code to fetch IC
      return 4;
    });
    ;
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

  // Chunk data to page and fetch
  Future<void> fetchFriends() async {
    List<Friend> temp = [...friendState.listFriend];
    List<Friend> friends = [];
    int pageKey = 0;
    final numberFriend = await getNumberOfFriend();

    do {
      friends = await getFriends(startAt: pageKey, pageSize: _friendPerPage);

      friends.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
      friends.forEach((element) {
        temp.removeWhere((elementQuery) => elementQuery.name == element.name);
      });
      temp.insertAll(0, friends);
      pageKey++;
    } while (friends.length == _friendPerPage);
    friendState.listFriend = temp;
  }

  Future<void> generateCode() async {
    // Example code to fetch friends from code gểnate
    friendState.setInviteCode(await Future.delayed(Duration(seconds: 1), () {
      return 'CuAJSTnT${DateTime.now().millisecondsSinceEpoch}';
    }));
  }

  Future<String> addInviteCode(String ic) async {
    return Future.delayed(Duration(seconds: 1), () {
      // Example code to fetch IC
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
