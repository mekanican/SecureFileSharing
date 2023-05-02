import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:sfs_frontend/helper/dio_option.dart';
import 'package:sfs_frontend/services/user_state.dart';

class UserController {

  final UserState userState;

  UserController(this.userState);

  Future<String?> signUp(SignupData sData) async {
    var dio = Dio(baseOptions);

    var response = await dio.post("/user/register", data: {
      'username': sData.name ?? '',
      'password': sData.password ?? '',
      'email': sData.additionalSignupData?["email"] ?? '',
    });
    Map<String, dynamic> data = jsonDecode(response.data);
    String? error;

    if (data.containsKey("password")) {
      List<String> p = data["password"];
      error = p[0];
    } else if(data.containsKey("username")) {
      List<String> p = data["username"];
      error = p[0];
    } else {
      String userId = data["user_id"];
      userState.login(sData.name ?? '', userId);
    }

    return error;
  }

  Future<String?> signIn(LoginData sData) async {
    var dio = Dio(baseOptions);

    var response = await dio.post("/user/login", data: {
      'username': sData.name,
      'password': sData.password,
    });
    Map<String, dynamic> data = jsonDecode(response.data);
    String? error;

    if (data.containsKey("password")) {
      List<String> p = data["password"];
      error = p[0];
    } else if(data.containsKey("username")) {
      List<String> p = data["username"];
      error = p[0];
    } else {
      String userId = data["user_id"];
      userState.login(sData.name, userId);
    }
    return error;
  }
}
