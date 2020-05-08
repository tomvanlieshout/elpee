import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:elpee/bloc/bloc.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatefulWidget {
  static final String routeName = '/forgot-password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String email;
  AuthBloc _bloc;
  bool _validator = false;
  bool _isLoading = true;

  @override
  void initState() {
    _bloc = BlocProvider.of<AuthBloc>(context);
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'elpee',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'burgundy',
                  fontSize: 32,
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.black,
            body: Form(
              key: _formKey,
              autovalidate: _validator,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        right: 48, left: 48, top: 32, bottom: 64),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Forgot Password.',
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: 'roboto',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 48.0, right: 48.0, bottom: 16),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) => _validateEmail(email),
                      onChanged: (value) => setState(() {
                        email = value.trim();
                      }),
                      cursorColor: Colors.amber,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.white70,
                        ),
                        icon: Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.65,
                    margin: EdgeInsets.only(top: size.height * 0.1),
                    child: OutlineButton(
                      onPressed: () async {
                        await _submitForm();
                      },
                      child: Text(
                        'Send reset email',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  String _validateEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (email.length == 0) {
      return "An email address is required.";
    } else if (!regExp.hasMatch(email)) {
      return "The email address is not valid.";
    } else {
      return null;
    }
  }

  bool _validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      setState(() {
        _validator = true;
      });
      return false;
    }
  }

  _submitForm() async {
    if (_validateForm()) {
      try {
        _bloc.add(ForgotPasswordEvent(email));
        _showFlushbar('An email has been sent to ' + email);
      } on AuthError catch(e) {
        _showFlushbar(e.message);
      }
    }
  }

  _showFlushbar(String message) {
    return Flushbar(
      message: message,
      duration: Duration(seconds: 4),
      isDismissible: true,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.black,
      borderRadius: 8,
      margin: EdgeInsets.all(5),
      borderColor: Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      icon: Icon(FeatherIcons.alertTriangle, color: Colors.amber),
      overlayBlur: 1,
      shouldIconPulse: false,
    ).show(context);
  }
}
