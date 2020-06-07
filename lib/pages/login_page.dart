import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:elpee/bloc/bloc.dart';
import 'package:elpee/pages/forgot_password.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elpee/helpers.dart';
import './sign_up_page.dart';

class LoginPage extends StatelessWidget {
  static final String routeName = '/login';
  final String errorMessage;

  LoginPage({this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
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
      body: LoginForm(errorMessage: errorMessage),
    );
  }
}

class LoginForm extends StatefulWidget {
  final String errorMessage;

  LoginForm({this.errorMessage});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthBloc _bloc;
  bool _validator = false;

  @override
  void initState() {
    _bloc = BlocProvider.of<AuthBloc>(context);
    // If the last login request results in an error
    // This callback shows it AFTER rendering is complete.
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          if (widget.errorMessage != null)
            {
              Helpers.showFlushbar(context, widget.errorMessage, Icon(FeatherIcons.alertTriangle, color: Colors.amber),
                  duration: 4, isDismissible: false),
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidate: _validator,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 48, left: 48, bottom: 32),
              alignment: Alignment.centerLeft,
              child: Text(
                'Log In.',
                style: TextStyle(
                  fontSize: 42,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48.0, right: 48.0, bottom: 16),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (email) => _validateEmail(email.trim()),
                onChanged: (value) => setState(() {
                  email = value.trim();
                }),
                cursorColor: Colors.amber,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
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
            Padding(
              padding: const EdgeInsets.only(left: 48.0, right: 48.0),
              child: TextFormField(
                cursorColor: Colors.amber,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.white70,
                  ),
                  icon: Icon(
                    Icons.lock,
                  ),
                ),
                onChanged: (value) => setState(() {
                  password = value;
                }),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(ForgotPassword.routeName),
              child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: size.width * 0.1, top: 12),
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 14),
                ),
              ),
            ),
            Container(
              width: size.width * 0.5,
              margin: EdgeInsets.only(top: 24),
              child: OutlineButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text(
                  'Log in',
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 8),
              child: Divider(
                indent: 32,
                endIndent: 32,
                thickness: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Text(
                'Don\'t have an account?',
                style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: OutlineButton(
                child: new Text(
                  'Sign up',
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.of(context).pushNamed(SignUp.routeName);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: Text(
                'or',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: FlatButton(
                child: new Text(
                  'Guest',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                color: Colors.white10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  _bloc.add(SignInAsGuest());
                },
              ),
            ),
          ],
        ),
      ),
    );
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

  _submitForm() {
    if (_validateForm()) {
      _bloc.add(SignInWithEmail(email, password));
    }
  }
}
