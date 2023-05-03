import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:sfs_frontend/pages/GuestRoute/guest_route.dart';
import 'package:sfs_frontend/services/user_state.dart';
import 'package:sfs_frontend/services/friend_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => FriendState()),
      ],
      child: MaterialApp(
        title: 'SFS',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.teal,
        ),
        home: const GuestRoute(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
