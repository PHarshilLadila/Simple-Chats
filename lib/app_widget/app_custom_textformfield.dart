// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextformfield extends StatelessWidget {
  final TextInputType? keybordType;
  final TextEditingController? controller;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextformfield({
    super.key,
    this.keybordType,
    this.controller,
    this.prefixIcon,
    this.labelText,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.onChanged,
    this.autofocus,
    this.focusNode,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keybordType,
      controller: controller,
      obscureText: obscureText!,
      autofocus: autofocus!,
      focusNode: focusNode,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColor.blackColor.withOpacity(0.6), width: 0.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColor.blackColor.withOpacity(0.6), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColor.blackColor.withOpacity(0.6), width: 0.5),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 0.5),
        ),
      ),
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
    );
  }
}
