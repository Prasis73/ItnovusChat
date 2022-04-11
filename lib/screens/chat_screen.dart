import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itnovus/model/remote_user.dart';
import 'package:itnovus/screens/auth_screen.dart';

import 'package:itnovus/widgets/chat/messages.dart';
import 'package:itnovus/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  final RemoteUser remoteUser;

  ChatScreen({required this.remoteUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${remoteUser.userName}"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (dynamic itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthScreen()));
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(
                remoteUser: remoteUser,
              ),
            ),
            NewMessage(
              remoteUser: remoteUser,
            ),
          ],
        ),
      ),
    );
  }
}
