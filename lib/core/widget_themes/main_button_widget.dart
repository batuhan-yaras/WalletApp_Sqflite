import 'package:flutter/material.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {super.key, required this.text, this.onPressed, this.height = 60, this.width = 210, this.fontSize = 15});
  final String text;
  final onPressed;
  final double height;
  final double width;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AllPaddings().mainButtonPadding,
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: TextFieldColors().fieldTitleColor,
            elevation: 6,
            foregroundColor: AllColors().bgColorFirst,
            textStyle: TextStyle(letterSpacing: 2, fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
