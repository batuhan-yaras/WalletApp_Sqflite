import 'package:flutter/material.dart';
import 'package:wallet_app/product/all_colors.dart';

//Title
class TitleStyles extends StatelessWidget {
  const TitleStyles({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .displayMedium
          ?.copyWith(color: TextFieldColors().fieldTitleColor, letterSpacing: 3),
    );
  }
}
