import 'package:flutter/material.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';

// Text we used in row
class TextRow extends StatelessWidget {
  const TextRow({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: TextFieldColors().fieldTitleColor, fontWeight: FontWeight.w300));
  }
}

//TextButton we used in row
class TextButtonRow extends StatelessWidget {
  const TextButtonRow({super.key, required this.text, required this.onPressed});
  final void Function() onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AllPaddings().inkwellPadding,
      child: InkWell(
        onTap: onPressed,
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: TextFieldColors().fieldTitleColor, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
