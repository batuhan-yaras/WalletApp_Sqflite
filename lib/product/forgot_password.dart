import 'package:flutter/material.dart';
import 'package:wallet_app/core/widget_themes/main_button_widget.dart';
import 'package:wallet_app/core/widget_themes/text_field_widget.dart';
import 'package:wallet_app/core/widget_themes/wallet_info_widgets.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_strings.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:wallet_app/view/user_list/model/user_database_provider.dart';

class EmailSenderAlertDialog extends StatefulWidget {
  const EmailSenderAlertDialog({super.key});

  @override
  State<EmailSenderAlertDialog> createState() => _EmailSenderAlertDialogState();
}

class _EmailSenderAlertDialogState extends State<EmailSenderAlertDialog> {
  final TextEditingController _emailController = TextEditingController();
  final UserDatabaseProvider _userDatabaseProvider = UserDatabaseProvider();

  @override
  void initState() {
    super.initState();
    _userDatabaseProvider.open(); // Veritabanını aç
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: TextFieldColors().fieldBorderColor,
      elevation: 10,
      icon: Icon(
        Icons.key,
        color: TextFieldColors().fieldBorderColor,
      ),
      title: const WalletInfoSubtitle(text: 'We will send your informations to your email address.'),
      backgroundColor: AllColors().forgotPasswordBG,
      actions: [
        TextFieldStyles(
          labeltext: AllStrings().emailAdress,
          fieldInputType: TextInputType.emailAddress,
          maxLength: 64,
          controller: _emailController,
        ),
        Center(
          child: MainButton(
            text: AllStrings().send,
            onPressed: () async {
              String email = _emailController.text.trim(); // Boşlukları temizle
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter an email address')),
                );
                return;
              }

              bool userExists = await _userDatabaseProvider.isEmailTaken(email);

              if (userExists) {
                bool sendStatus = await _sendEmail(email);
                if (sendStatus) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email sent successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to send email')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email not registered')),
                );
              }

              Navigator.pop(context);
            },
            height: 40,
            width: 140,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Future<bool> _sendEmail(String recipientEmail) async {
    bool sendStates = false;
    try {
      final user = await _userDatabaseProvider.getUserByEmail(recipientEmail);

      String username = 'your_email';
      String password = 'your_password';

      final smtpServer = gmail(username, password); // Gmail SMTP sunucusunu kullan

      // Mesajı oluştur
      final message = Message()
        ..from = Address(username, 'Wallet App')
        ..recipients.add(recipientEmail)
        ..subject = 'Wallet App Informations'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html =
            "<h1>Your Wallet's Informations</h1>\n<p>Email address: $recipientEmail\n<p>Username: ${user?.username}\n<p>Password: ${user?.password}</p>";

      // E-postayı gönder
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
      sendStates = true; // Gönderim başarılıysa true olarak ayarla
    } on MailerException catch (e) {
      debugPrint('Message not sent.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }

    return sendStates;
  }
}
