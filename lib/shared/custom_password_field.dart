import 'package:flutter/material.dart';
import 'package:parkang_admin/shared/shared_code.dart';

class CustomPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const CustomPasswordField({Key? key, required this.label, required this.controller}) : super(key: key);

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 5.0),
        TextFormField(
            controller: widget.controller,
            validator: SharedCode.passwordValidator,
            obscureText: !_isShowPassword,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _isShowPassword = !_isShowPassword;
                  });
                },
                child: Icon(
                  _isShowPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
              ),
            )
        ),
      ],
    );
  }
}
