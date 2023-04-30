import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: (_){}, 
      onRecoverPassword: (_){},
      onSignup: (_){},
      logo: AssetImage("logo/logo_icon.png"),
      );
  }
}