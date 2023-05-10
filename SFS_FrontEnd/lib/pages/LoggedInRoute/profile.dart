import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sfs_frontend/helper/datetime.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final textController = TextEditingController();

  final usrController = TextEditingController();
  final emailController = TextEditingController();
  final statusController = TextEditingController();

  var isUsernameChanged = false;


  @override
  void dispose() {
    usrController.dispose();
    emailController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // On create dialog!,
    // Todo: Change to api request to check for user first appearance
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _showDialogRequestKey(!await checkFirstTime());
    });
    setInitialProfileData();
  }

  Future<bool> checkFirstTime() async {
    // This will be checked by testing key file is represent on this computer
    Directory dir = await getApplicationSupportDirectory();
    String path = dir.path;
    const String fileName = "key.json";
    return File("$path/$fileName").exists();
  }

  Future<void> setInitialProfileData() async {
    usrController.text = "Unknown";
    emailController.text = "mrX@example.com";
    statusController.text = "Not assigned"; // Assigned at 01/01/2069
  }



  Future<String?> _showDialogRequestKey(bool isFirstTime) async {

    Text content;
    if (isFirstTime) {
      content = const Text("Welcome to your first login to our system!\nDo you want to create the new key (must have to start sending file)?\nThe request may take a few second");
    } else {
      content = const Text("It seems like you want to change the key!\nFiles you received in the past will not be accessible forever.\nContinue?");
    }

    return showDialog<String>(
        context: context,
        barrierDismissible: false, // Cannot tap outside
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Key request'),
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print('Cancel');
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print('OK');
                statusController.text = "Assigned at ${getCurrentDate()}";
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetCircularAnimator(
            size: 150,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey[200]),
              child: Icon(
                Icons.person_outline,
                color: Colors.deepOrange[200],
                size: 60,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth * 0.5,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: Column(children: [
                  TextField(
                    controller: usrController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder()
                    ),
                    onChanged: (_) => {
                      if (!isUsernameChanged) {
                        setState(() => {
                          isUsernameChanged = true
                        })
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    readOnly: true,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: statusController,
                    enabled: false,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Key status",
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                    if (isUsernameChanged) TextButton(onPressed: () => {}, child: Text("Update profile")),
                    TextButton(onPressed: () async => _showDialogRequestKey(false), child: Text("Change key")),
                  ],)
                ]),
              );
            }
          )
        ],
      ),
    );
  }
}
