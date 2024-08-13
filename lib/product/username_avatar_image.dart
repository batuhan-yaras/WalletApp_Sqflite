import 'package:flutter/material.dart';
import 'package:wallet_app/product/all_colors.dart';

CircleAvatar UsernameAvatar() {
  return CircleAvatar(
      radius: 50,
      backgroundImage: const AssetImage('assets/userIcon.png'),
      backgroundColor: TextFieldColors().fieldTitleColor);
}
