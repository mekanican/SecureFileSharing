import 'package:flutter/material.dart';
import 'package:sfs_frontend/models/friend.dart';
import 'package:sfs_frontend/services/friend_controller.dart';

class FriendState extends ChangeNotifier {
  List<Friend> listFriend = [];
  String inviteCode = "";

  List<Friend> getListFriend() {
    return listFriend;
  }

  String getInviteCode() {
    return inviteCode;
  }

  void setInviteCode(String ic) {
    inviteCode = ic;
    notifyListeners();
  }

  void setListFriend(List<Friend> list) {
    listFriend = list;
    notifyListeners();
  }
}
