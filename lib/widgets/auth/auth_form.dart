import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itnovus/screens/resetpassword_screen.dart';

import 'package:itnovus/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final Future<void> Function(
    String email,
    String password,
    String userName,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_isLogin == false && _userImageFile==null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }


    if (isValid) {

        _formKey.currentState!.save();
        widget.submitFn(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _userImageFile,
          _isLogin,
          context,
        );

    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.blue])),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.person_outline,color: Colors.white,size: 40,),
                  Text("Welcome", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ) ,),
                  Text("ITNOVUS", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ) ,),
                  SizedBox(height: 20,),
                  if (!_isLogin) UserImagePicker(_pickedImage),
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
                      focusColor: Colors.grey,
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius. circular(10.0),),
                    ),
                    onSaved: (value) {
                      if (value != null) {
                        _userEmail = value;
                      }
                    },
                  ),  SizedBox(height: 10,),
                  if (!_isLogin)

                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.grey),
                        border:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors. white, width: 2.0),
                          borderRadius: BorderRadius. circular(10.0),),
                      ),
                      onSaved: (value) {
                        if (value != null) {
                          _userName = value;
                        }
                      },
                    ),
                  SizedBox(height: 10,),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white60,

                      border:OutlineInputBorder(

                        borderSide: const BorderSide(color: Colors.white60, width: 5.0),
                        borderRadius: BorderRadius. circular(10.0),
                      ),),
                    obscureText: true,
                    onSaved: (value) {
                      if (value != null) {
                        _userPassword = value;
                      }
                    },
                  ),
                  if (_isLogin)
                    Row(
                      children: [
                        TextButton(onPressed: ()=>Navigator.of(context).
                        push(MaterialPageRoute(builder: (context)=>ResetPassword())),
                            child: Text("Forgot Password?",style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),)),
                      ],
                    ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(

                      child: Text(_isLogin ? 'Login' : 'Signup',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),),
                      onPressed: _trySubmit,
                    ),



                  if (!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
