import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class Helpers {
  static showFlushbar(BuildContext context, String message, Icon icon, {int duration, bool isDismissible, Color backgroundColor, Color borderColor}) {
    return Flushbar(
      message: message,
      duration: Duration(seconds: duration ?? 3),
      isDismissible: isDismissible ?? true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.black,
      borderRadius: 8,
      margin: EdgeInsets.all(5),
      borderColor: borderColor ?? Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      icon: icon,
      overlayBlur: 1,
      shouldIconPulse: false,
    ).show(context);
  }
}
