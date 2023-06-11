import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example code to download file
    // getApplicationSupportDirectory().then((value) => downloadFile("https://www.google.com/robots.txt", "${value.path}/robots.txt"));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage("logo/logo_full.png"))
        ],
      ),
    );
  }
}