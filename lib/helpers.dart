import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class Helpers {
  static showFlushbar(BuildContext context, String message, Icon icon,
      {int duration,
      bool isDismissible,
      Color backgroundColor,
      Color borderColor,
      FlushbarPosition position,
      bool shouldIconPulse,
      EdgeInsets margin}) {
    return Flushbar(
      message: message,
      duration: Duration(seconds: duration ?? 3),
      isDismissible: isDismissible ?? true,
      flushbarPosition: position ?? FlushbarPosition.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.black,
      borderRadius: 8,

      borderColor: borderColor ?? Colors.white,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      icon: icon,
      routeBlur: 1,
      shouldIconPulse: shouldIconPulse ?? false,
      margin: margin ?? EdgeInsets.all(16),
    ).show(context);
  }
}
