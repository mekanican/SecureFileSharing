import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void refresh() async {
    var l = await friendController.getListFriend();
    print(l);
    setState(() {
      _listFriend = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    userState = context.watch<UserState>();
    friendController = FriendController(userState);

    _timer = Timer.periodic(const Duration(seconds: 20), (_) async {
      refresh();
    });

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            // onChanged: (_) => _pagingController.refresh(),
            decoration: InputDecoration(
              hintText: 'Search friends',
              border: InputBorder.none,
            ),
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () async => refresh(),
            child: ListView.builder(
              itemCount: _listFriend.length,
              itemBuilder: (context, index) {
                final friend = _listFriend[index];
                final avatar = friend.name.isNotEmpty
                    ? friend.name[0].toUpperCase()
                    : '';
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
                        ChatPage(),
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return ListTile(
                        leading: CircleAvatar(child: Text(avatar)),
                        title: Text(friend.name),
                        subtitle: Text(
                            'Last message at ${friend.lastMessageAt.toString()}'),
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
        ));
  }
}