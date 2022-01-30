import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class SharedCode {
  static final numberFormat = NumberFormat('#,##0');

  static String? emptyValidator(value) {
    return value.toString().trim().isEmpty ? 'Field can\'t be blank' : null;
  }

  static String? passwordValidator(value) {
    return value.toString().length < 6 ? 'Password must be at least 6 characters' : null;
  }

  static String? emailValidator(value) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    return !emailValid ? 'Invalid email' : null;
  }

  static void navigatorReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => widget));
  }

  static void navigatorPush(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => widget));
  }

  static void navigatorPushAndRemoveUntil(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
    widget), (Route<dynamic> route) => false);
  }

  // static void showErrorDialog(BuildContext context, String title, String content) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return CustomErrorDialog(title: title, content: content);
  //       });
  // }

  static void showConfirmationDialog(BuildContext context, String title, String message, VoidCallback onYesTap) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(child: const Text('Tidak'), onPressed: () => Navigator.of(context).pop()),
        TextButton(child: const Text('Ya'), onPressed: onYesTap)
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showSnackBar(BuildContext context, String status, String content) {
    Color color = Colors.green;
    switch (status) {
      case 'success':
        color = Colors.green;
        break;
      case 'error':
        color = Colors.red;
        break;
    }
    SnackBar snackBar = SnackBar(
      content: Text(content, style: GoogleFonts.poppins(color: Colors.white)),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}