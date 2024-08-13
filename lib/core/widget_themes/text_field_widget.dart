import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';

// TextField
class TextFieldStyles extends StatelessWidget {
  const TextFieldStyles({
    super.key,
    required this.labeltext,
    this.iconField, // nullable iconField
    required this.fieldInputType,
    required this.maxLength,
    this.invisibleBool = false,
    this.onChanged,
    this.controller,
  });

  final IconData? iconField; // nullable iconField
  final String labeltext;
  final TextInputType fieldInputType;
  final int maxLength;
  final bool invisibleBool;
  final void Function(String)? onChanged; // nullable onChanged
  final TextEditingController? controller; // nullable controller

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AllPaddings().textFieldPadding,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: invisibleBool,
        style: TextStyle(color: TextFieldColors().fieldTitleColor),
        autofocus: false,
        cursorColor: TextFieldColors().fieldTitleColor,
        keyboardType: fieldInputType,
        inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
        decoration: InputDecoration(
          icon: iconField != null ? Icon(iconField) : null, // Check if iconField is null
          iconColor: TextFieldColors().fieldTitleColor,
          floatingLabelStyle: TextStyle(color: TextFieldColors().fieldTitleColor),
          labelText: labeltext,
          labelStyle: TextStyle(color: TextFieldColors().fieldLabelColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: TextFieldColors().fieldTitleColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: TextFieldColors().fieldBorderColor,
            ),
          ),
        ),
      ),
    );
  }
}
