import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:sfs_frontend/services/friend_controller.dart';
import 'package:sfs_frontend/services/user_state.dart';

class FriendCodePage extends StatefulWidget {
  const FriendCodePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FriendCodePage();
  }
}

class _FriendCodePage extends State<FriendCodePage> {
  late UserState userState;
  late FriendController friendController;
  late String _userInviteCode = "";
  final _inviteCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userState = Provider.of<UserState>(context, listen: false);
      friendController = FriendController(userState);
      getCode();
    });
  }

  void getCode() async {
    String userCode = await friendController.getCode();
    setState(() {
      _userInviteCode = userCode;
    });
  }

  void generateCode() async {
    String userCode = await friendController.generateCode();
    setState(() {
      _userInviteCode = userCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Code'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Give your friend this invite code")),
            CopyToClipboardText(text: _userInviteCode),
            const SizedBox(height: 16.0),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Or")),
            TextField(
              controller: _inviteCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter invite code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final inviteCode = _inviteCodeController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invite code submitted: $inviteCode'),
                  ),
                );
                friendController
                    .addInviteCodeHandler(inviteCode)
                    .then((res) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(res),
                          ),
                        ));
              },
              child: const Text('Add Friend'),
            ),
            ElevatedButton(
              onPressed: () {
                generateCode();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              child: const Text('Generate code'),
            ),
          ],
        ),
      ),
    );
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
