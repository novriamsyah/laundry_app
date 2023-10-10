import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ShowSnackbarCustom {
  static void showCustomSnackbarSuccess(BuildContext context, String message) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
    ).show(context);
  }

  static void showCustomSnackbarError(BuildContext context, String message) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    ).show(context);
  }
}
