import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:sfs_frontend/pages/chat.dart';
import 'package:sfs_frontend/pages/home.dart';
import 'package:sfs_frontend/pages/friend.dart';
import 'package:sfs_frontend/pages/login.dart';
import 'package:sfs_frontend/services/user_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserState(),
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
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = LoginPage();
        break;
      case 2:
        page = FriendListPage();
        break;
      case 3:
        page = ChatPage();
        break;
      default:
        throw UnimplementedError("Not found");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            getHorizontalNavigationBar(constraints),
            Expanded(child: Container(color: Colors.white, child: page))
          ],
        ),
      );
    });
  }

  SafeArea getHorizontalNavigationBar(BoxConstraints constraints) {
    return SafeArea(
        child: NavigationRail(
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text("Home")),
        NavigationRailDestination(
            icon: Icon(Icons.login), label: Text("Login")),
        NavigationRailDestination(
            icon: Icon(Icons.supervised_user_circle),
            label: Text("List of friends")),
        NavigationRailDestination(icon: Icon(Icons.chat), label: Text("Chat")),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) {
        setState(() {
          selectedIndex = value;
        });
      },
      extended: constraints.maxWidth >= 700,
      backgroundColor: Colors.lime.shade300,
    ));
  }
}
