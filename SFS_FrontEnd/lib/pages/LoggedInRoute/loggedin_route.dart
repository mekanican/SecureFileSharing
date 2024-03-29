import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sfs_frontend/pages/GuestRoute/guest_route.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/friend.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/profile.dart';
import 'package:sfs_frontend/pages/home.dart';
import 'package:sfs_frontend/services/user_state.dart';

class LoggedInRoute extends StatefulWidget {
  const LoggedInRoute({super.key, required this.title});

  final String title;

  @override
  State<LoggedInRoute> createState() => _LoggedInRouteState();
}

class _LoggedInRouteState extends State<LoggedInRoute> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    var userState = context.watch<UserState>();
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const FriendListPage();
        break;
      case 2:
        page = const ProfilePage();
        break;
      default:
        throw UnimplementedError("Not found");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            getHorizontalNavigationBar(context, userState, constraints),
            Expanded(child: Container(color: Colors.white, child: page))
          ],
        ),
      );
    });
  }

  SafeArea getHorizontalNavigationBar(
      BuildContext context, UserState userState, BoxConstraints constraints) {
    return SafeArea(
        child: NavigationRail(
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text("Home")),
        NavigationRailDestination(
            icon: Icon(Icons.supervised_user_circle),
            label: Text("List of friends")),
        NavigationRailDestination(
            icon: Icon(Icons.perm_device_information_outlined),
            label: Text("Profile")),
        NavigationRailDestination(
            icon: Icon(Icons.logout), label: Text("Log out")),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) {
        // TODO: hardcoded value, need change in future
        if (value == 3) {
          userState.logout();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const GuestRoute(title: "Guest")));
        } else {
          setState(() {
            selectedIndex = value;
          });
        }
      },
      extended: constraints.maxWidth >= 700,
      backgroundColor: Colors.lime.shade300,
    ));
  }
}
