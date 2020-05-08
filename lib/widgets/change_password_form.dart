import 'package:elpee/bloc/bloc.dart';
import 'package:elpee/helpers.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  AuthBloc _bloc;
  String currentPassword, newPassword, newPasswordConfirm;
  bool validate = false;

  @override
  void initState() {
    _bloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  String _validatePassword(String pass) {
    if (pass.length < 6) {
      return 'Password needs to be at least 6 characters.';
    }
    return null;
  }

  String _validateNewPassword(String newPassword, String newPasswordConfirm) {
    if (newPassword != newPasswordConfirm) {
      return 'New password and the confirmation must be equal.';
    }
    return null;
  }

  bool _validateForm() {
    if (_formKey.currentState.validate() &&
        _validatePassword(currentPassword) == null &&
        _validateNewPassword(newPassword, newPasswordConfirm) == null) {
      _formKey.currentState.save();
      return true;
    } else {
      setState(() {
        validate = true;
      });
      return false;
    }
  }

  _submitForm() async {
    if (_validateForm()) {
      try {
        _bloc.add(ChangePassword(currentPassword, newPassword));
        Navigator.of(context).pop();
      } on AuthError catch (e) {
        Helpers.showFlushbar(context, e.message, Icon(FeatherIcons.alertTriangle, color: Colors.amber), duration: 4, isDismissible: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new AlertDialog(
        title: const Text('Delete account'),
        backgroundColor: Colors.black,
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: validate,
            child: new Column(
              children: <Widget>[
                Text('Enter your password to confirm'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Current password'),
                    maxLines: 1,
                    onChanged: (_) => setState(() {
                      currentPassword = _.trim();
                    }),
                    validator: (pass) => _validatePassword(pass),
                    autofocus: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'New password'),
                    validator: (pass) => _validatePassword(pass),
                    maxLines: 1,
                    onChanged: (_) => setState(() {
                      newPassword = _.trim();
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'New password (confirm)'),
                    validator: (pass) => _validateNewPassword(newPassword, pass),
                    maxLines: 1,
                    onChanged: (_) => setState(() {
                      newPasswordConfirm = _.trim();
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5),
            child: OutlineButton(
              child: Text('Close'),
              borderSide: BorderSide(color: Colors.white, width: 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: OutlineButton(
              child: Text('Confirm', style: TextStyle(color: Colors.green)),
              borderSide: BorderSide(color: Colors.green, width: 1),
              onPressed: () {
                _submitForm();
              },
            ),
          ),
        ],
      ),
    );
  }
}
