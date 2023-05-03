import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/loggedin_route.dart';
import 'package:sfs_frontend/services/user_controller.dart';
import 'package:sfs_frontend/services/user_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userState = context.watch<UserState>();
    var userController = UserController(userState);
    return FlutterLogin(
      onLogin: userController.dummySignIn, // TODO: Replace with  userController.signIn
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoggedInRoute(title: "Logged In"))
        );
      },
    );
  }
}