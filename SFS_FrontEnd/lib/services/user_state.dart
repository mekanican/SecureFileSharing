import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  String username = "";
  String token = "";
  int userId = 0;

  void login(String newUserName, String newToken, int newUserId) {
    username = newUserName;
    token = newToken;
    userId = newUserId;
    notifyListeners();
  }

  void logout() {
    username = "";
    token = "";
    userId = 0;
    notifyListeners();
  }

  bool isLogin() {
    return username != "" && token != "";
  }

  String getUsername() {
    return username;
  }

  String getToken() {
    return token;
  }

  int getId() {
    return userId;
  }
}
