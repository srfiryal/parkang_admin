import 'package:flutter/material.dart';
import 'package:parkang_admin/services/auth_service.dart';
import 'package:parkang_admin/shared/custom_password_field.dart';
import 'package:parkang_admin/shared/custom_text_field.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/shared/shared_code.dart';
import 'package:parkang_admin/wrapper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    } else {
      _isLoading = isLoading;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildAllWidgets();
  }

  Widget _buildAllWidgets() {
    return Scaffold(
      appBar: AppBar(title: const Text('P A R K A N G   A D M I N')),
      body: _isLoading
          ? const Loading()
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey.shade300,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
                      child: const Text('LOGIN',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                          CustomTextField(
                              label: 'Email Address',
                              controller: _emailController,
                              validator: SharedCode.emailValidator),
                          const SizedBox(height: 10.0),
                          CustomPasswordField(
                              label: 'Password',
                              controller: _passwordController),
                          const SizedBox(height: 25.0),
                          OutlinedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                              child: const Text('LOGIN')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _login() async {
    _setLoading(true);
    try {
      var res = await AuthService().loginWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (res is String) {
        SharedCode.showSnackBar(context, 'error', res);
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const Wrapper()));
      }
    } catch (e) {
      SharedCode.showSnackBar(context, 'error', e.toString());
    }
    _setLoading(false);
  }
}
