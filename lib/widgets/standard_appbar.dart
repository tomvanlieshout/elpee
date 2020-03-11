import 'package:flutter/material.dart';
import '../pages/home.dart';

class StandardAppbar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            ModalRoute.withName(Home.routeName),
          );
        },
        child: Text(
          'elpee',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
