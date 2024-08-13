//login başarısız alerti oluşturulacak.

import 'package:flutter/material.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';

class LoginFailed extends StatelessWidget {
  const LoginFailed({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AllColors().errorContainer,
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
