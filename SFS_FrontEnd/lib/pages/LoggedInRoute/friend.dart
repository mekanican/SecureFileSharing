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
  final _pagingController = PagingController<int, Friend>(firstPageKey: 0);
  final _searchController = TextEditingController();
  String ic = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 20), (_) {
      _pagingController.refresh();
    });
  }

  Future<void> _handleRefresh() async {
    _pagingController.refresh();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final friendState = context.watch<FriendState>();
    final friendController = FriendController(friendState);

    _pagingController.addPageRequestListener((pageKey) async {
      try {
        final query = _searchController.text;
        final isLastPage = await friendController.fetchPage(pageKey);
        friendState.filterFriends(query);
        if (isLastPage) {
          _pagingController.appendLastPage(friendState.listFriend);
        } else {
          final nextPageKey = pageKey + 1;

          _pagingController.appendPage(friendState.listFriend, nextPageKey);
        }
      } catch (error) {
        _pagingController.error = error;
      }
    });
    // Set up the page request listener

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            onChanged: (_) => _pagingController.refresh(),
            decoration: InputDecoration(
              hintText: 'Search friends',
              border: InputBorder.none,
            ),
          ),
        ),
        body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: PagedListView<int, Friend>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Friend>(
                  itemBuilder: (_, friend, index) {
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
            )),
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
  final String text;

  const CopyToClipboardText({required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Copied to clipboard')));
      },
      child: Text(text),
    );
  }
}

class _FriendCodePage extends StatelessWidget {
  String ic = "";

  @override
  Widget build(BuildContext context) {
    final friendState = context.watch<FriendState>();
    final friendController = FriendController(friendState);
    friendController.generateCode();

    return Scaffold(
      appBar: AppBar(title: const Text('Details page'), actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ]),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CopyToClipboardText(text: friendState.inviteCode),
          Text('Or '),
          TextField(
            decoration: InputDecoration(hintText: "Enter friend's code"),
            onChanged: (value) => ic = value,
          ),
        ],
      ),
    );
  }
}
