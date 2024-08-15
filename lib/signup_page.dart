import 'package:flutter/material.dart';
import 'package:wallet_app/core/init/database/database_service.dart';
import 'package:wallet_app/core/widget_themes/login_signup_row.dart';
import 'package:wallet_app/core/widget_themes/main_button_widget.dart';
import 'package:wallet_app/core/widget_themes/text_field_widget.dart';
import 'package:wallet_app/core/widget_themes/title_styles.dart';
import 'package:wallet_app/login_page.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';
import 'package:wallet_app/product/all_strings.dart';
import 'package:wallet_app/core/login_signup_alert.dart';
import 'package:wallet_app/view/user_list/model/user_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _signupErrorUsername = false;
  bool _signupErrorEmail = false;
  bool _signupErrorBoth = false;

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
                child: TitleStyles(text: AllStrings().register),
              ),
              TextFieldStyles(
                  controller: _emailController,
                  labeltext: 'Email',
                  iconField: Icons.email,
                  fieldInputType: TextInputType.emailAddress,
                  maxLength: 64),
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
              if (_signupErrorBoth) LoginFailed(text: AllStrings().signupFailedBoth, color: AllColors().errorContainer),
              if (_signupErrorUsername)
                LoginFailed(text: AllStrings().signupFailedUsername, color: AllColors().errorContainer),
              if (_signupErrorEmail)
                LoginFailed(text: AllStrings().signupFailedEmail, color: AllColors().errorContainer),
              MainButton(
                text: AllStrings().signup,
                onPressed: () {
                  saveModel();
                  setState(() {
                    _signupErrorBoth = false;
                    _signupErrorEmail = false;
                    _signupErrorUsername = false;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextRow(text: AllStrings().alreadyHave),
                  TextButtonRow(
                    text: AllStrings().login,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
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

  Future<void> saveModel() async {
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = int.tryParse(_passwordController.text) ?? 0;

    final isUsernameTaken = await DatabaseService().userDatabaseProvider.isUsernameTaken(username);
    final isEmailTaken = await DatabaseService().userDatabaseProvider.isEmailTaken(email);

    if (isUsernameTaken && isEmailTaken) {
      setState(() {
        _signupErrorBoth = true;
      });
    } else if (isUsernameTaken) {
      setState(() {
        _signupErrorUsername = true;
      });
    } else if (isEmailTaken) {
      setState(() {
        _signupErrorEmail = true;
      });
    } else {
      final userModel = UserModel(
        email: email,
        username: username,
        password: password,
      );

      final result = await DatabaseService().userDatabaseProvider.insert(userModel);
      if (result) {
        print('Kullanıcı başarıyla eklendi.');
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        });
        showDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            context: context,
            builder: (BuildContext context) {
              return SignedInSuccessfully(
                  textTitle: AllStrings().successfulRegister, textSubtitle: AllStrings().registerSubTitle);
            });
      } else {
        print('Kullanıcı eklenirken bir hata oluştu.');
      }
    }
  }
}
