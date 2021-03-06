import 'package:color_run/authentication/authentication.dart';
import 'package:color_run/constants/inputs_decorations.dart';
import 'package:color_run/helpers/widgets_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  //handle email and password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //registering
  final Authentication _authentication = Authentication();

  //show snakbar in bottom
  void _showBottomSnackBar(Widget content) =>
      Scaffold.of(context).showSnackBar(SnackBar(
          content: content,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(60, 12, 44, 1)));

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final ProgressDialog _progressDialog =
        WidgetHelpers().getDialogLinearDialog(context, "Registering...");

    Future registerWithEmailAndPassword() async {
      await _progressDialog.show();
      dynamic result = await _authentication.registerWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      await _progressDialog.hide();
      if (result is String) {
        _showBottomSnackBar(Text(result));
      } else {
        print((result as AuthResult).user.uid);
      }
    }

    return Form(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputLoginTextDecoration.copyWith(
                hintText: "Enter Email",
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              onFieldSubmitted: (val) => focus.requestFocus(),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputLoginTextDecoration.copyWith(
                hintText: "Enter Password",
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              focusNode: focus,
              onFieldSubmitted: (val) async {
                focus.unfocus();
                await registerWithEmailAndPassword();
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                color: Color.fromRGBO(244, 13, 193, 1),
                onPressed: () async {
                  await registerWithEmailAndPassword();
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                color: Color.fromRGBO(170, 138, 183, 1),
                onPressed: () async {
                  dynamic result = await _authentication.loginWithGoogle();
                  if (result is String) {
                    _showBottomSnackBar(Text(result));
                  }
                },
                child: Text(
                  "Register with google",
                  style: TextStyle(
                      color: Color.fromRGBO(34, 12, 44, 1),
                      fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
