import 'package:sfs_frontend/services/friend_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FriendCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendCodePage();
  }
}

class _FriendCodePage extends State<FriendCodePage> {
  String ic = "";
  final _inviteCodeController = TextEditingController();
  String _userInviteCode = "";
  final friendController = FriendController();
  @override
  void initState() {
    super.initState();
    fetchInit();
  }

  void fetchInit() async {
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
            Padding(
                child: Text("Give your friend this invite code"),
                padding: const EdgeInsets.symmetric(vertical: 8)),
            CopyToClipboardText(text: _userInviteCode),
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
