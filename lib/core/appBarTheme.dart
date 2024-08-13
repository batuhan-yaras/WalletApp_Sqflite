import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_app/product/all_colors.dart';

AppBarTheme appBar_Theme() =>
    AppBarTheme(color: AllColors().appBarThemeColor, systemOverlayStyle: SystemUiOverlayStyle.light);
