import 'package:flutter/material.dart';
import 'package:kingslabs_mt/core/constants/app_colors.dart';



class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType inputType;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.inputType = TextInputType.text,
    this.validator, 
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final _textFormFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _textFormFieldKey, 
      style: const TextStyle(color: AppColors.primaryColor),
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.inputType,
      validator: widget.validator,
      onTap: () {
        setState(() {
          _textFormFieldKey.currentState?.reset();
        });

        widget.onTap?.call();
      },
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: AppColors.primaryColor),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.primaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
      ),
    );
  }
}