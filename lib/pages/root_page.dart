import 'package:elpee/bloc/bloc.dart';
import 'package:elpee/pages/home.dart';
import 'package:elpee/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatefulWidget {
  static final String routeName = '/root';
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AuthBloc>(context);
    _bloc.add(FetchUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is AuthInitial) {
            // TODO
            // return SplashScreen();
            return Center(child: CircularProgressIndicator());
          } else if (state is AuthenticatedState) {
            return Home();
          } else if (state is UnauthenticatedState) {
            return LoginPage();
          } else if (state is AuthLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AuthError) {
            return LoginPage(errorMessage: state.message);
          } else if (state is DeleteSuccessfulState) {
            return LoginPage(errorMessage: state.result);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
