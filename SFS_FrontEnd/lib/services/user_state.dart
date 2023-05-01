import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  String username = "";
  String token = "";

  void login(String newUserName, String newToken) {
    username = newUserName;
    token = newToken;
    notifyListeners();
  }

  void logout() {
    username = "";
    token = "";
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
}