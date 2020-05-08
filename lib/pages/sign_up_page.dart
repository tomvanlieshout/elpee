import 'package:elpee/helpers.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elpee/bloc/bloc.dart';

class SignUp extends StatefulWidget {
  static final String routeName = '/sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String username, email, password;
  AuthBloc _bloc;
  bool _validator = false;

  @override
  initState() {
    _bloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
      body: Form(
        key: _formKey,
        autovalidate: _validator,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 48, left: 48, top: 32, bottom: 32),
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign Up.',
                style: TextStyle(
                  fontSize: 36,
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
                cursorColor: Colors.amber,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.white70,
                  ),
                  icon: Icon(
                    Icons.mail,
                  ),
                ),
                validator: (email) => _validateEmail(email.trim()),
                onChanged: (value) => setState(() {
                  email = value.trim();
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48.0, right: 48.0, bottom: 16),
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
                validator: (pass) => _validatePassword(pass),
                onChanged: (value) => setState(() {
                  password = value;
                }),
              ),
            ),
            Container(
              width: size.width * 0.5,
              margin: EdgeInsets.only(top: 32),
              child: OutlineButton(
                onPressed: _submitForm,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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

  String _validatePassword(String pass) {
    if (pass.length < 6) {
      return 'Password needs to be at least 6 characters.';
    }
    return null;
  }

  bool _validateForm() {
    if (_formKey.currentState.validate() && _validateEmail(email) == null && _validatePassword(password) == null) {
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
        _bloc.add(SignUpWithEmail(email, password));
        _bloc.listen((state) {
          if (state is AuthenticatedState) {
            if (mounted) {
              Helpers.showFlushbar(
                  context,
                  'Thank you for signing up! You are now logged in.',
                  Icon(
                    Icons.check,
                    color: Colors.green,
                  ));
            }
          }
        });
      } on AuthError catch (e) {
        Helpers.showFlushbar(context, e.message, Icon(FeatherIcons.alertTriangle, color: Colors.amber), duration: 4, isDismissible: false);
      }
    }
  }
}
