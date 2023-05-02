import 'package:flutter/material.dart';

import '../home.dart';
import 'login.dart';

class GuestRoute extends StatefulWidget {
  const GuestRoute({super.key, required this.title});

  final String title;

  @override
  State<GuestRoute> createState() => _GuestRouteState();
}

class _GuestRouteState extends State<GuestRoute> {
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
