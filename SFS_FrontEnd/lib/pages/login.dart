import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:sfs_frontend/services/user_controller.dart';
import 'package:sfs_frontend/services/user_state.dart';

// For testing only
const users = {
  'nva': '12345',
  'nvb': 'hunter',
};

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Duration get loginTime => const Duration(milliseconds: 2250);
  // Future<String?> _authUser(LoginData data) {
  //   debugPrint('Name: ${data.name}, Password: ${data.password}');
  //   return Future.delayed(loginTime).then((_) {
  //     if (!users.containsKey(data.name)) {
  //       return 'User not exists';
  //     }
  //     if (users[data.name] != data.password) {
  //       return 'Password does not match';
  //     }
  //     return null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var userState = context.watch<UserState>();
    var userController = UserController(userState);
    return FlutterLogin(
      onLogin: userController.signIn, 
      onRecoverPassword: (_){},
      onSignup: userController.signUp,
      logo: AssetImage("logo/logo_icon.png"),
      userType: LoginUserType.name,
      additionalSignupFields: const [
        UserFormField(
          keyName: "email",
          displayName: "Email",
          icon: Icon(Icons.email),
          userType: LoginUserType.email,
          fieldValidator: FlutterLogin.defaultEmailValidator
        )
      ],
      userValidator: (_) => null,
      onSubmitAnimationCompleted:() {
        print("Logged ${userState.getUsername()} in successfully");
      },
      );
  }
}
