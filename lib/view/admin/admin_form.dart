import 'package:flutter/material.dart';
import 'package:parkang_admin/services/auth_service.dart';
import 'package:parkang_admin/shared/custom_password_field.dart';
import 'package:parkang_admin/shared/custom_text_field.dart';
import 'package:parkang_admin/shared/loading.dart';
import 'package:parkang_admin/shared/shared_code.dart';

class AdminForm extends StatefulWidget {
  const AdminForm({Key? key}) : super(key: key);

  @override
  _AdminFormState createState() => _AdminFormState();
}

class _AdminFormState extends State<AdminForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Admin')),
      body: _isLoading
          ? const Center(child: Loading())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                          label: 'Name',
                          controller: _nameController,
                          validator: SharedCode.emptyValidator),
                      CustomTextField(
                          label: 'Email',
                          controller: _emailController,
                          validator: SharedCode.emailValidator),
                      CustomPasswordField(
                          label: 'Password', controller: _passwordController),
                      const SizedBox(height: 15),
                      OutlinedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addAdmin();
                            }
                          },
                          child: const Text('Add')),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    } else {
      _isLoading = isLoading;
    }
  }

  Future<void> _addAdmin() async {
    _setLoading(true);
    try {
      var res = await AuthService().registerWithEmailAndPassword(
          name: _nameController.text, email: _emailController.text, password: _passwordController.text, role: 'admin');
      _setLoading(false);
      if (res is String) {
        SharedCode.showSnackBar(context, 'error', res);
      } else {
        SharedCode.showSnackBar(context, 'success', 'Admin has been added');
        Navigator.pop(context);
      }
    } catch (e) {
      _setLoading(false);
      SharedCode.showSnackBar(context, 'error', e.toString());
    }
  }
}
