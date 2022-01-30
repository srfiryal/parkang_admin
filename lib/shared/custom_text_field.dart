import 'package:flutter/material.dart';
import 'package:parkang_admin/shared/shared_code.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final validator;

  const CustomTextField({Key? key, required this.label, required this.controller, this.validator}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    dynamic validator = widget.validator;
    validator ?? SharedCode.emptyValidator;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: widget.controller,
          validator: validator,
        ),
      ],
    );
  }
}
