import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/core/constants/layout_constants.dart';
import 'package:notes_app/product/constants/typography_constants.dart';
import 'package:notes_app/product/theme/theme_styles.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      style: bodyXL.white, 
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: bodyXL.copyWith(color: Colors.grey[400]),
        filled: true,
        fillColor: ThemeStyles.grayColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.radius12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.radius12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.radius12),
          borderSide: BorderSide(
            color: ThemeStyles.primaryColor,
            width: LayoutConstants.size2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.radius12),
          borderSide: BorderSide(
            color: ThemeStyles.errorColor,
            width: LayoutConstants.size2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutConstants.radius12),
          borderSide: BorderSide(
            color: ThemeStyles.errorColor,
            width: LayoutConstants.size2,
          ),
        ),
        suffixIcon: suffixIcon,
        contentPadding: LayoutConstants.padding16All,
      ),
    );
  }
}