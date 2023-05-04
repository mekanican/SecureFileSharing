import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sfs_frontend/models/friend.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/chat.dart';
import 'package:sfs_frontend/services/friend_controller.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sfs_frontend/services/friend_state.dart';
import 'package:provider/provider.dart';

class FriendListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendListPageState();
  }
}

class _FriendListPageState extends State<FriendListPage> {
  final _searchController = TextEditingController();
  bool _isInitialized = false; // for render 1 time
  String ic = ""; // input invite code
  List<Friend> _listFriend = []; //local state for search

  @override
  void initState() {
    super.initState();
  }

  //fetch once component start
  Future<void> fetchInit(
      FriendState friendState, FriendController friendController) async {
    await friendController.generateCode();
    await friendController.fetchFriends();
    setState(() {
      _listFriend = friendState.listFriend;
    });
  }

  //Handle refresh
  void refreshFresh(
      FriendState friendState, FriendController friendController) async {
    await friendController.fetchFriends();
    setState(() {
      _listFriend = friendState.listFriend;
    });
  }

  // Filter friend with text
  void filterFriend(FriendState friendState, String text) {
    final query = text;
    if (!query.isEmpty) {
      setState(() {
        _listFriend = friendState.listFriend
            .where((friend) =>
                friend.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _listFriend = friendState.listFriend;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set up the page request listener
    final friendState = context.watch<FriendState>();
    final friendController = FriendController(friendState);
    if (!_isInitialized) {
      fetchInit(friendState, friendController)
          .then((value) => _isInitialized = true);
    }

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            onChanged: (_) => filterFriend(friendState, _searchController.text),
            decoration: InputDecoration(
              hintText: 'Search friends',
              border: InputBorder.none,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async => refreshFresh(friendState, friendController),
          child: ListView.builder(
              itemCount: _listFriend.length,
              itemBuilder: (context, index) {
                // avatar
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
                        ChatPage(),
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return ListTile(
                        leading: CircleAvatar(child: Text(avatar)),
                        title: Text(friend.name),
                        subtitle: Text(
                            'Last message at ${DateTime.now().isDateEqual(friend.lastMessageAt) ? DateFormat.jm().format(friend.lastMessageAt) : DateFormat.yMd().add_jm().format(friend.lastMessageAt)}'),
                      );
                    },
                  ),
                );
              }),
        ),
        floatingActionButton: OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          openBuilder: (BuildContext context, VoidCallback _) {
            return _FriendCodePage();
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

extension CompareDates on DateTime {
  bool isDateEqual(DateTime date2) {
    return year == date2.year && month == date2.month && day == date2.day;
  }
}

class CopyToClipboardText extends StatelessWidget {
  const CopyToClipboardText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _copyToClipboard(context, text),
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () => _copyToClipboard(context, text),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
      ),
    );
  }
}

class _FriendCodePage extends StatelessWidget {
  String ic = "";

  final _inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final friendState = context.watch<FriendState>();
    final friendController = FriendController(friendState);

    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Code'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                child: Text("Give your friend this invite code"),
                padding: const EdgeInsets.symmetric(vertical: 8)),
            CopyToClipboardText(text: friendState.inviteCode),
            SizedBox(height: 16.0),
            Padding(
                child: Text("Or"),
                padding: const EdgeInsets.symmetric(vertical: 8)),
            TextField(
              controller: _inviteCodeController,
              decoration: InputDecoration(
                labelText: 'Enter invite code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final inviteCode = _inviteCodeController.text;
                // TODO: Store the invite code or send it to a server
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invite code submitted: $inviteCode'),
                  ),
                );

                friendController
                    .addIC(inviteCode)
                    .then((res) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$res'),
                          ),
                        ));
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
