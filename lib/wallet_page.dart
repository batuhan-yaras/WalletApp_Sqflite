import 'package:flutter/material.dart';
import 'package:wallet_app/core/widget_themes/main_button_widget.dart';
import 'package:wallet_app/core/widget_themes/text_field_widget.dart';
import 'package:wallet_app/core/widget_themes/wallet_info_widgets.dart';
import 'package:wallet_app/login_page.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';
import 'package:wallet_app/product/all_strings.dart';
import 'package:wallet_app/product/username_avatar_image.dart';

//herkese rastgele money atayacağım. Chatgpt de var.
class WalletPageView extends StatelessWidget {
  final String email;
  final String username;
  final int id;
  final double money;
  const WalletPageView({super.key, required this.email, required this.username, required this.id, required this.money});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Sekme sayısı
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AllColors().bgColorFirst,
        appBar: AppBar(
          actions: [
            Padding(
              padding: AllPaddings().inkwellPadding,
              child: IconButton(
                icon: const Icon(Icons.logout),
                color: TextFieldColors().fieldTitleColor,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
          backgroundColor: AllColors().bottomTabColor,
          centerTitle: true,
          title: Text(AllStrings().walletAppBar,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(wordSpacing: 1, color: TextFieldColors().fieldTitleColor)),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0), // Bu, AppBar'da yer kaplamasını önler
            child: SizedBox.shrink(),
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
                padding: AllPaddings().appPadding + AllPaddings().topPadding,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(child: Padding(padding: const EdgeInsets.only(bottom: 40, top: 20), child: UsernameAvatar())),
                  Divider(
                    color: TextFieldColors().fieldLabelColor,
                  ),
                  _sizedBoxHalf(),
                  WalletInfoTitle(text: AllStrings().emailAdress),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: email),
                  _sizedBoxFull(),
                  WalletInfoTitle(text: AllStrings().username),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: username),
                  _sizedBoxFull(),
                  WalletInfoTitle(text: AllStrings().amountOfMoney),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: '$money \$'),
                  _sizedBoxFull(),
                  WalletInfoTitle(text: AllStrings().walletId),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: '$id')
                ])),
            Padding(
                padding: AllPaddings().appPadding + AllPaddings().topPadding,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(child: Padding(padding: const EdgeInsets.only(bottom: 60, top: 20), child: UsernameAvatar())),
                  WalletInfoTitle(text: AllStrings().transferMoneytoAnother),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: AllStrings().receiverInfos),
                  const TextFieldStyles(
                      labeltext: 'Username', iconField: null, fieldInputType: TextInputType.name, maxLength: 20),
                  const TextFieldStyles(
                      labeltext: 'Wallet ID', iconField: null, fieldInputType: TextInputType.name, maxLength: 20),
                  const TextFieldStyles(
                      labeltext: 'Amount', iconField: null, fieldInputType: TextInputType.name, maxLength: 20),
                  MainButton(
                    text: AllStrings().send,
                    onPressed: () {},
                    height: 40,
                    width: 140,
                    fontSize: 12,
                  ),
                ])),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: AllColors().bottomTabColor,
          child: TabBar(
            dividerColor: TextFieldColors().fieldLabelColor,
            indicatorColor: TextFieldColors().fieldTitleColor,
            tabs: [
              Tab(text: AllStrings().walletInfo),
              Tab(text: AllStrings().sendMoney),
            ],
            labelColor: TextFieldColors().fieldTitleColor, // Sekme etiketlerinin rengi
            unselectedLabelColor: TextFieldColors().fieldLabelColor, // Seçilmemiş sekme etiketlerinin rengi
          ),
        ),
      ),
    );
  }

  SizedBox _sizedBoxFull() => const SizedBox(height: 40);
  SizedBox _sizedBoxHalf() => const SizedBox(height: 20);
}
