import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sfs_frontend/models/friend.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/chat.dart';
import 'package:sfs_frontend/services/friend_controller.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sfs_frontend/pages/LoggedInRoute/code_page.dart';

class FriendListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendListPageState();
  }
}

class _FriendListPageState extends State<FriendListPage> {
  final _searchController = TextEditingController();
  String ic = ""; // input invite code
  List<Friend> _listFriend = []; //local state for search
  final friendController = FriendController();
  final _pagingController = PagingController<int, Friend>(firstPageKey: 0);
  Timer? _timer;
  final _friendPerPage = 3;

  @override
  void initState() {
    super.initState();

    // Set up the timer to call _pagingController.refresh() every second
    _timer = Timer.periodic(Duration(seconds: 20), (_) {
      _pagingController.refresh();
    });

    // Set up the page request listener
    _pagingController.addPageRequestListener((pageKey) async {
      try {
        final query = _searchController.text;
        final friends = await friendController.fetchPage(pageKey);
        final isLastPage = friends.length < _friendPerPage;
        List<Friend> afterFilter = _filterFriends(friends);
        if (isLastPage) {
          _pagingController.appendLastPage(afterFilter);
        } else {
          final nextPageKey = pageKey + 1;
          print("pageKey:  $nextPageKey");
          _pagingController.appendPage(afterFilter, nextPageKey);
        }
      } catch (error) {
        _pagingController.error = error;
      }
    });
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

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
            onRefresh: () async => _pagingController.refresh(),
            child: PagedListView<int, Friend>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Friend>(
                itemBuilder: (_, friend, index) {
                  print("Build in $friend");
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
                          ChatPage(other_id: 0),
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
                },
              ),
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

extension CompareDates on DateTime {
  bool isDateEqual(DateTime date2) {
    return year == date2.year && month == date2.month && day == date2.day;
  }
}
