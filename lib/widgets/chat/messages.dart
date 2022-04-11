import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itnovus/model/remote_user.dart';

import 'package:itnovus/widgets/chat/message_bubble.dart';

class Messages extends StatefulWidget {
  final RemoteUser remoteUser;

  Messages({required this.remoteUser});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<Map<String, dynamic>> filteredItems(List<Map<String, dynamic>> items) {
    final _currentUser = FirebaseAuth.instance.currentUser!;

    List<Map<String, dynamic>> _tempList = [];

    List<String> _roomUsers = [_currentUser.uid, widget.remoteUser.uid];

    for (Map<String, dynamic> val in items) {
      if (_roomUsers.contains(val["userId"]) &&
          _roomUsers.contains(val["receiverId"])) {
        _tempList.add(val);
      }
    }
    return _tempList;
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<Map<String, dynamic>> chatDocs =
            (chatSnapshot.data?.docs ?? []).map((e) => e.data()).toList();

        final _filteredList = filteredItems(chatDocs);

        return ListView.builder(
          reverse: true,
          itemCount: _filteredList.length,
          itemBuilder: (ctx, index) {
            return MessageBubble(
              _filteredList[index]['text'],
              _filteredList[index]['username'],
              _filteredList[index]['userImage'],
              _filteredList[index]['userId'] == _currentUser?.uid,
            );
          },
        );
      },
    );
  }
}
