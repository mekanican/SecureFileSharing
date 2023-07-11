import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:sfs_frontend/helper/file_handler.dart';
import 'package:sfs_frontend/helper/md5.dart';
import 'package:sfs_frontend/helper/rsa.dart';
import 'package:sfs_frontend/helper/chain.dart';
import 'package:sfs_frontend/helper/signature.dart';
import 'package:sfs_frontend/helper/socketio_handler.dart';
import 'package:sfs_frontend/models/signed_data.dart';

import 'package:sfs_frontend/services/chat_controller.dart';
import 'package:sfs_frontend/services/detect_controller.dart';
import 'package:sfs_frontend/services/key_controller.dart';
import 'package:sfs_frontend/services/upload_controller.dart';
import 'package:sfs_frontend/services/user_state.dart';

import 'package:sfs_frontend/models/chat.dart';
import 'package:sfs_frontend/models/data.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.otherID});
  final int otherID;

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];

  late types.User user;

  late UserState userState;
  late ChatController chatController;
  late KeyController keyController;
  late UploadController uploadController;

  DetectController detectController = DetectController();

  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserState>(context, listen: false);
    chatController = ChatController(userState);
    keyController = KeyController(userState);
    uploadController = UploadController(userState);
    Socket sk = Socket();
    int userID = userState.userId;
    sk.sk.on("Reload $userID", (data) async => await refresh());
    user = types.User(id: userID.toString());
    refresh();
  }

  Future<void> refresh() async {
    if (mounted) {
      List<ChatMessage> l = await chatController.getChat(widget.otherID);
      setState(() {
        _messages = l.map((e) => e.toFileMessage()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Chat(
        messages: _messages,
        onSendPressed: (_) {},
        onAttachmentPressed: _handleFileSelection,
        onMessageTap: _handleMessageTap,
        user: user,
      ),
    );
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var uri = message.uri;
      var filename = message.name;
      if (message.author.id == userState.userId.toString()) {
        return;
      }
      if (uri.startsWith("http")) {
        try {
          // Load spinner
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(isLoading: true);
          setState(() {
            _messages[index] = updatedMessage;
          });

          var randomName = randomString();
          await downloadFile(uri, randomName);
          var data = await openFile(randomName);
          var privKey = await getPrivKey(userState.userId);

          RSAPublicKey pubkey = await keyController.getOtherPubKey(widget.otherID);
          SignedData sd = SignedData.fromBytes(data);
          if (!Signature.checkSignature(sd.data.encryptedKey, sd.signature, pubkey)) {
            //  Wrong signature, abort;
            return;
          }
          

          var trueData = Chain.decrypt(privKey, sd.data);
          var result = await FilePicker.platform.getDirectoryPath();
          var f = File("$result/$filename");
          f.writeAsBytes(trueData);
          print("Written to $result/$filename");
        } finally {
          // Remove spinner
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(isLoading: null);
          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }
    }
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null && result.files.single.path != null) {
      var file = File(result.files.single.path!);
      var data = await file.readAsBytes();

      var hashData = MD5.getHash(data);
      bool r = await detectController.detect(hashData);
      if (r) {
        //Malware -> skip
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Malware detected, abort!")));
        }
        return;
      }

      RSAPublicKey pubkey = await keyController.getOtherPubKey(widget.otherID);
      RSAPrivateKey privKey = await getPrivKey(userState.userId);

      Data d = Chain.encrypt(pubkey, data);
      var sig = Signature.getSignature(d.encryptedKey, privKey); 
      SignedData sd = SignedData(sig, d);

      await uploadController.upload(
          widget.otherID, result.files.single.name, sd.toBase64());
    }
  }
}
