import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itnovus/model/remote_user.dart';
import 'package:itnovus/screens/chat_screen.dart';

import 'auth_screen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver{
  @override

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    setStatus("Online");
  }
  void setStatus(String status)async{
    await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
      "status":status,
    });

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state==AppLifecycleState.resumed){
      //online
      setStatus("Online");
    }else{
      //offline
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Members"),
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
                setStatus("Offline");
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthScreen()));
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("email")
            .where("image_url").where("status")
            .where("uid", isNotEqualTo: _user?.uid)
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // final docs=streamSnapshot.data?.docs;

          final _remoteDocs = streamSnapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: _remoteDocs.length,
            itemBuilder: (ctx, index) {
              final RemoteUser _remoteUsers = RemoteUser.fromJson(
                  Map<String, dynamic>.from(_remoteDocs[index].data()));

              return Container(color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          textColor: Colors.pink,
                          trailing: Column(
                            children: [
                             Icon(Icons.online_prediction_sharp,color: _remoteDocs[index]['status']=="Online"?Colors.green:Colors.grey),


                            ],
                          ),
                          title: Text(
                            _remoteUsers.userName,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 20
                          ),
                          ),


                          leading:ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image(image: NetworkImage(_remoteUsers.userImage),height: 50,width: 50,),
                          ),
                          onTap: () {
                            if (_remoteUsers.uid.isEmpty) {
                              print("Receiver not found");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    remoteUser: _remoteUsers,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
