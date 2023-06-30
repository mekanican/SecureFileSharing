import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sfs_frontend/helper/socketio_handler.dart';
import 'package:sfs_frontend/models/friend_clone.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/chat.dart';
import 'package:sfs_frontend/services/friend_controller.dart';
import 'package:animations/animations.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/code_page.dart';
import 'package:sfs_frontend/services/user_state.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FriendListPageState();
  }
}

class _FriendListPageState extends State<FriendListPage> {
  late UserState userState;
  late FriendController friendController;
  List<Friend> _listFriend = []; //local state for search

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userState = Provider.of<UserState>(context, listen: false);
      friendController = FriendController(userState);
      var sk = Socket();
      var currentID = userState.userId;
      sk.sk.on("Reload $currentID", (data) async => await refresh());
      await refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refresh() async {
    if (mounted) {
      var l = await friendController.getListFriend();
      setState(() {
        _listFriend = l;
      });
    }
  }

  void _onCloseContainer(Object? arg) {
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Friends List")
        ),
        body: RefreshIndicator(
            onRefresh: () async => await refresh(),
            child: ListView.builder(
              itemCount: _listFriend.length,
              itemBuilder: (context, index) {
                final friend = _listFriend[index];
                final avatar =
                    friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '';
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedColor: Theme.of(context).cardColor,
                    closedElevation: 0.0,
                    openElevation: 4.0,
                    transitionDuration: const Duration(milliseconds: 1500),
                    openBuilder: (BuildContext context, VoidCallback _) =>
                        ChatPage(otherID: friend.id),
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return ListTile(
                        leading: CircleAvatar(child: Text(avatar)),
                        title: Text(friend.name),
                        subtitle: friend.lastMessageAt.toString() != "null"
                            ? Text(
                                'Last message at ${friend.lastMessageAt.toString()}')
                            : Text(''),
                      );
                    },
                  ),
                );
              },
            )),
        floatingActionButton: OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          openBuilder: (BuildContext context, VoidCallback _) {
            return FriendCodePage();
          },
          closedElevation: 6.0,
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(56 / 2),
            ),
          ),
          closedColor: Theme.of(context).colorScheme.secondary,
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return SizedBox(
              height: 56,
              width: 56,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            );
          },
          onClosed: _onCloseContainer,
        ));
  }
}
