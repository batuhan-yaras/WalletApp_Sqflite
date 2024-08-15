//login başarısız alerti oluşturulacak.

import 'package:flutter/material.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';

class LoginFailed extends StatelessWidget {
  const LoginFailed({super.key, required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(6)), // Köşeleri yuvarlama
      ),
      child: Center(
        child: Padding(
          padding: AllPaddings().errorTextPadding,
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AllColors().errorColor),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}

class SignedInSuccessfully extends StatelessWidget {
  const SignedInSuccessfully({super.key, required this.textTitle, required this.textSubtitle});
  final String textTitle;
  final String textSubtitle;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        textTitle,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold, color: TextFieldColors().fieldTitleColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: TextFieldColors().fieldBorderColor),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: AllColors().successfulColor,
      elevation: 10.0,
    );
  }
}
