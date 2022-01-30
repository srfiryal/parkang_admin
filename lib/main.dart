import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkang_admin/view/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkang Admin',
      theme: ThemeData(
        primaryColor: Colors.blueGrey.shade700,
        primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black, displayColor: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade700,
          elevation: 0.0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 18.0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey.shade200,
          filled: true,
          contentPadding: const EdgeInsets.all(10.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
            backgroundColor: Colors.grey.shade200,
            elevation: 0.0,
            minimumSize: const Size(double.infinity, 40.0),
            side: const BorderSide(color: Colors.black, width: 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
      home: const Login(),
    );
  }
}