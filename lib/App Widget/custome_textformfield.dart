import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';

class CustomeTextformfield extends StatelessWidget {
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

  const CustomeTextformfield({
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
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColor.mainColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColor.mainColor,
          ),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
    );
  }
}
