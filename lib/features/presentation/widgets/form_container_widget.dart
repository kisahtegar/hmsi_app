import 'package:flutter/material.dart';

import '../../../const.dart';

class FormContainerWidget extends StatefulWidget {
  final Key? fieldKey;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool? isPasswordField;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? iconsField;

  const FormContainerWidget({
    Key? key,
    this.fieldKey,
    this.controller,
    this.inputType,
    this.isPasswordField,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.hintText,
    this.labelText,
    this.helperText,
    this.iconsField,
  }) : super(key: key);

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          key: widget.fieldKey,
          controller: widget.controller,
          keyboardType: widget.inputType,
          obscureText: widget.isPasswordField == true ? _obscureText : false,
          onSaved: widget.onSaved,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            icon: Icon(
              widget.iconsField,
              color: Colors.black,
            ),
            fillColor: Colors.transparent,
            border: InputBorder.none,
            filled: true,
            hintText: widget.hintText,
            // hintStyle: TextStyle(fontSize: 12),
            suffixIcon: widget.isPasswordField == true
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color:
                          _obscureText == false ? Colors.black : secondaryColor,
                    ),
                  )
                : const Text(""),
          ),
        ),
      ),
    );
  }
}
