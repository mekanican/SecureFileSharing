import 'package:dio/dio.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:sfs_frontend/helper/dio_option.dart';
import 'package:sfs_frontend/services/user_state.dart';

class UserController {
  final UserState userState;

  UserController(this.userState);

  Future<String?> signUp(SignupData sData) async {
    var dio = Dio(baseOptions);

    var response = await dio.post("/user/register/", data: {
      'username': sData.name ?? '',
      'password': sData.password ?? '',
      'email': sData.additionalSignupData?["email"] ?? '',
    });
    return processSignupResponse(response);
  }

  String? processSignupResponse(Response<dynamic> response) {
    Map<String, dynamic> data = response.data;
    String? error;
    
    if (data.containsKey("password")) {
      error = "";
      List<dynamic> p = data["password"];
      for (String e in p) {
        error = "${error!} $e";
      }
    } else if (data.containsKey("username")) {
      error = "";
      List<dynamic> p = data["username"];
      for (String e in p) {
        error = "${error!} $e";
      }
    } else {
      error = "Register successfully, please verify email and log in";
    }
    return error;
  }

  Future<String?> signIn(LoginData sData) async {
    var dio = Dio(baseOptions);

    var response = await dio.post("/user/login/", data: {
      'username': sData.name,
      'password': sData.password,
    });
    return processSigninResponse(response, sData);
  }

  String? processSigninResponse(Response<dynamic> response, LoginData sData) {
    Map<String, dynamic> data = response.data;
    String? error;
    
    if (data.containsKey("error")) {
      error = data["error"];
    } else {
      String token = data["token"];
      int userId = data["user_id"];
      userState.login(sData.name, token, userId);
    }
    return error;
  }
}
