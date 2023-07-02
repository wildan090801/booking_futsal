import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorPopupFlushbar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.black),
    ),
    animationDuration: const Duration(seconds: 1),
    borderRadius: BorderRadius.circular(12),
    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
    padding: const EdgeInsets.all(10),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.white,
    icon: const Icon(
      Icons.cancel,
      size: 28.0,
      color: Colors.red,
    ),
    duration: const Duration(seconds: 2),
  ).show(context);
}

void showSuccessPopupFlushbar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.black),
    ),
    animationDuration: const Duration(seconds: 1),
    borderRadius: BorderRadius.circular(12),
    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
    padding: const EdgeInsets.all(10),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.white,
    icon: const Icon(
      Icons.check_circle,
      size: 28.0,
      color: Color(0xff00C92E),
    ),
    duration: const Duration(seconds: 2),
  ).show(context);
}
