import 'package:flutter/material.dart';
import 'package:wallet_app/core/widget_themes/login_signup_row.dart';
import 'package:wallet_app/core/widget_themes/main_button_widget.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';
import 'package:wallet_app/product/all_strings.dart';
import 'package:wallet_app/core/widget_themes/text_field_widget.dart';
import 'package:wallet_app/core/widget_themes/title_styles.dart';
import 'package:wallet_app/product/login_signup_alert.dart';
import 'package:wallet_app/signup_page.dart';
import 'package:wallet_app/view/user_list/model/user_database_provider.dart';
import 'package:wallet_app/wallet_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserDatabaseProvider _userDatabaseProvider = UserDatabaseProvider();
  bool _loginFailed = false;

  @override
  void initState() {
    super.initState();
    _userDatabaseProvider.open(); // Veritabanı bağlantısını aç
  }

  Future<void> _login() async {
    var username = _usernameController.text;
    final password = int.tryParse(_passwordController.text) ?? 0;

    final user = await _userDatabaseProvider.getUserByCredentials(username, password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WalletPageView(
            email: user.email!,
            username: user.username!,
            id: user.id!,
            money: user.money ??= 100.0,
          ),
        ),
      );
    } else {
      setState(() {
        _loginFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AllColors().bgColorFirst,
      appBar: AppBar(leading: const Text('')),
      body: SingleChildScrollView(
        child: Padding(
          padding: AllPaddings().appPadding,
          child: Column(
            children: [
              Padding(
                padding: AllPaddings().titlePadding,
                child: TitleStyles(text: AllStrings().welcomeTitleText),
              ),
              TextFieldStyles(
                  controller: _usernameController,
                  labeltext: 'Username',
                  iconField: Icons.account_circle,
                  fieldInputType: TextInputType.name,
                  maxLength: 20),
              TextFieldStyles(
                  controller: _passwordController,
                  labeltext: 'Password',
                  iconField: Icons.key,
                  fieldInputType: TextInputType.number,
                  maxLength: 6,
                  invisibleBool: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButtonRow(
                  text: AllStrings().forgotPassword,
                  onPressed: () {},
                ),
              ),
              if (_loginFailed)
                LoginFailed(
                  color: AllColors().errorContainer,
                  text: AllStrings().loginFailed,
                ),
              MainButton(
                text: AllStrings().login,
                onPressed: () {
                  _login();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextRow(text: AllStrings().newHere),
                  TextButtonRow(
                    text: AllStrings().signup,
                    onPressed: () {
                      Future.delayed(Durations.long4);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
