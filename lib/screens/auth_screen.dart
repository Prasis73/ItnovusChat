import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:itnovus/screens/dash_screen.dart';

import 'package:itnovus/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
      //  FirebaseAuth.instance.signOut();
        try{
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,

        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
        setState(() {
          _isLoading = false;
        });}
        on FirebaseAuthException catch(error){
          setState(() {
            _isLoading = false;
          });
          print(error.message);
          String a=error.message as String;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(a),
              backgroundColor: Colors.green,
            ),
          );
        }

      //  print(authResult);
      } else if (image != null) {
        try{
          authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,

        );
          setState(() {
            _isLoading = false;
             isLogin=true;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
          print("testtttttttttttttt");


        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');

        final _uploadTask = await ref.putFile(image);

        if (_uploadTask.state == TaskState.success) {
          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': username,
            'email': email,
            'image_url': url,
            'status':"Offline",
            'uid': authResult.user!.uid,
          });
        }}on FirebaseAuthException catch(error){
          setState(() {
            _isLoading = false;
          });
          print(error.message);
          String a=error.message as String;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(a),
              backgroundColor: Colors.green,
            ),
          );
        }





      }
    } on PlatformException catch (err) {
      String? message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink, Colors.orange])),
      child: Scaffold(
        body: AuthForm(
          _submitAuthForm,
          _isLoading,
        ),
      ),
    );
  }
}
