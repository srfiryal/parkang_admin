import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkang_admin/services/database_service.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/view/drawer_navigation.dart';
import 'package:parkang_admin/view/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Widget _widget = const Login();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((event) {
      user = event;
    });
    _fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return const Loading();
  }

  Future<void> _fetchData() async {
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        String role = await DatabaseService().getUserRole(user!.uid);
        if (role == 'admin') {
          _widget = const DrawerNavigation();
        } else {
          _widget = const Login();
        }
      } catch (e) {
        print(e.toString());
        _widget = const Login();
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => _widget));
    }
   );
  }
}
