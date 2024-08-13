import 'package:flutter/material.dart';
import 'package:wallet_app/product/all_colors.dart';

class WalletInfoTitle extends StatelessWidget {
  const WalletInfoTitle({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: TextFieldColors().fieldTitleColor));
  }
}

class WalletInfoSubtitle extends StatelessWidget {
  const WalletInfoSubtitle({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: TextFieldColors().fieldBorderColor));
  }
}
