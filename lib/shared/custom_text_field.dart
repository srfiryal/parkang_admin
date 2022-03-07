import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkang_admin/shared/shared_code.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final validator;
  final TextInputType textInputType;
  final int minLines;

  const CustomTextField({Key? key, required this.label, required this.controller, this.validator, this.textInputType = TextInputType.text, this.minLines = 1}) : super(key: key);

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
          keyboardType: widget.textInputType,
          controller: widget.controller,
          minLines: widget.minLines,
          maxLines: null,
          validator: validator,
          inputFormatters: (widget.textInputType == TextInputType.phone || widget.textInputType == TextInputType.number) ? [
            FilteringTextInputFormatter.digitsOnly,
          ] : [],
        ),
      ],
    );
  }
}
