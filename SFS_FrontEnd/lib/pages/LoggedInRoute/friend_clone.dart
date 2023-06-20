import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sfs_frontend/helper/socketio_handler.dart';
import 'package:sfs_frontend/models/friend_clone.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/chat.dart';
import 'package:sfs_frontend/services/friend_clone_controller.dart';
import 'package:animations/animations.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/code_page.dart';
import 'package:sfs_frontend/services/user_state.dart';

class FriendListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendListPageState();
  }
}

class _FriendListPageState extends State<FriendListPage> {
  final _searchController = TextEditingController();
  late UserState userState;
  late FriendController friendController;
  List<Friend> _listFriend = []; //local state for search
  Timer? _timer;
  String _inputText = '';
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userState = Provider.of<UserState>(context, listen: false);
      friendController = FriendController(userState);
      var sk = Socket();
      var current_id = userState.userId;
      sk.sk.on("Reload $current_id", (data) async => await refresh());
      await refresh();
    });
    _timer = null;
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
    }
    super.dispose();
  }

  Future<void> refresh() async {
    if (this.mounted) {
      var l = await friendController.getListFriend();
      setState(() {
        _listFriend = _filterFriends(l);
      });
    }
  }

  List<Friend> _filterFriends(List<Friend> friends) {
    try {
      final query = _searchController.text;
      if (query.isEmpty) {
        return friends;
      } else {
        return friends
            .where((friend) =>
                friend.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } catch (err) {
      return friends;
    }
  }

  //bounding for input
  void _onTextChanged(String newText) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: 300), () {
      // Code to be executed after 300ms delay
      refresh();
    });
  }

  void _onCloseContainer(Object? arg) {
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            onChanged: _onTextChanged,
            decoration: InputDecoration(
              hintText: 'Search friends',
              border: InputBorder.none,
            ),
          ),
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
                    transitionDuration: Duration(milliseconds: 1500),
                    openBuilder: (BuildContext context, VoidCallback _) =>
                        ChatPage(other_id: friend.id),
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
