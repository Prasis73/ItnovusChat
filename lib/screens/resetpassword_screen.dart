import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itnovus/screens/auth_screen.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _email = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      auth.sendPasswordResetEmail(email: _email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reset link is sent to entered mail if registered"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthScreen()));


    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("something went wrong"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "reset",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Reset Password"),
          backgroundColor: Colors.pink,
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple, Colors.blue]),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(color: Colors.grey),
                          border:OutlineInputBorder(

                            borderSide: const BorderSide(color: Colors.white60, width: 5.0),
                            borderRadius: BorderRadius. circular(10.0),
                          ),
                        ),
                        onSaved: (value) {
                          if (value != null) {
                            _email = value;
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pinkAccent,
                      ),
                        child: Text("reset"),


                        onPressed: () {
                          setState(() {
                            _trySubmit();
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
