import 'package:flutter/material.dart';
import 'package:parkang_admin/shared/custom_password_field.dart';
import 'package:parkang_admin/shared/custom_text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildAllWidgets();
  }

  Widget _buildAllWidgets() {
    return Scaffold(
      appBar: AppBar(title: const Text('PARKANG ADMIN')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey.shade300,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: const Text('LOGIN', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
                    child: Text('Admin login.'),
                  ),
                  CustomTextField(label: 'Email Address', controller: _emailController),
                  const SizedBox(height: 10.0),
                  CustomPasswordField(label: 'Password', controller: _passwordController),
                  const SizedBox(height: 25.0),
                  OutlinedButton(onPressed: () {}, child: const Text('LOGIN')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
