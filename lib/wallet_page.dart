import 'package:flutter/material.dart';
import 'package:wallet_app/core/widget_themes/main_button_widget.dart';
import 'package:wallet_app/core/widget_themes/text_field_widget.dart';
import 'package:wallet_app/core/widget_themes/wallet_info_widgets.dart';
import 'package:wallet_app/login_page.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_paddings.dart';
import 'package:wallet_app/product/all_strings.dart';
import 'package:wallet_app/product/login_signup_alert.dart';
import 'package:wallet_app/product/username_avatar_image.dart';
import 'package:wallet_app/view/user_list/model/user_database_provider.dart';

//herkese rastgele money atayacağım. Chatgpt de var.
class WalletPageView extends StatefulWidget {
  final String email;
  final String username;
  final int id;
  final double money;

  const WalletPageView({super.key, required this.email, required this.username, required this.id, required this.money});

  @override
  State<WalletPageView> createState() => _WalletPageViewState();
}

class _WalletPageViewState extends State<WalletPageView> {
  final _usernameController = TextEditingController();
  final _walletIdController = TextEditingController();
  final _amountController = TextEditingController();

  final UserDatabaseProvider _userDatabaseProvider = UserDatabaseProvider();

  late double _currentMoney;
  @override
  void initState() {
    super.initState();
    _currentMoney = widget.money;
    _userDatabaseProvider.open(); // Veritabanını aç
  }

  Future<void> _transferMoney() async {
    final username = _usernameController.text.trim();
    final walletIdString = _walletIdController.text.trim();
    final amountString = _amountController.text.trim();

    if (username.isEmpty || walletIdString.isEmpty || amountString.isEmpty) {
      print('Transfer başarısız.');
      return;
    }

    final walletId = int.tryParse(walletIdString);
    final amount = double.tryParse(amountString);

    if (walletId == null || amount == null) {
      print('Transfer başarısız.2');
      return;
    }

    final recipientUser = await _userDatabaseProvider.getItem(walletId);
    if (recipientUser == null || recipientUser.username != username) {
      print('Kullanıcı uyuşmuyor.');
      return;
    }

    if (amount <= 0 || amount > widget.money) {
      print('Geçersiz miktar.');
      return;
    }

    await _userDatabaseProvider.transferMoney(widget.id, walletId, amount);
    print('Transfer başarılı.');
    showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (BuildContext context) {
          return SignedInSuccessfully(
              textTitle: AllStrings().transferTitle, textSubtitle: AllStrings().transferSubTitle);
        });

    setState(() {
      _currentMoney -= amount; // Kullanıcının mevcut bakiyesini güncelle
    });
  }

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
                  WalletInfoSubtitle(text: widget.email),
                  _sizedBoxFull(),
                  WalletInfoTitle(text: AllStrings().username),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: widget.username),
                  _sizedBoxFull(),
                  WalletInfoTitle(text: AllStrings().amountOfMoney),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: '$_currentMoney \$'),
                  _sizedBoxFull(),
                  WalletInfoTitle(text: AllStrings().walletId),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: '${widget.id}')
                ])),
            Padding(
                padding: AllPaddings().appPadding + AllPaddings().topPadding,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(child: Padding(padding: const EdgeInsets.only(bottom: 60, top: 20), child: UsernameAvatar())),
                  WalletInfoTitle(text: AllStrings().transferMoneytoAnother),
                  _sizedBoxHalf(),
                  WalletInfoSubtitle(text: AllStrings().receiverInfos),
                  TextFieldStyles(
                    labeltext: 'Username',
                    controller: _usernameController,
                    iconField: null,
                    fieldInputType: TextInputType.name,
                    maxLength: 20,
                  ),
                  TextFieldStyles(
                      controller: _walletIdController,
                      labeltext: 'Wallet ID',
                      iconField: null,
                      fieldInputType: TextInputType.name,
                      maxLength: 20),
                  TextFieldStyles(
                      controller: _amountController,
                      labeltext: 'Amount',
                      iconField: null,
                      fieldInputType: TextInputType.name,
                      maxLength: 20),
                  MainButton(
                    text: AllStrings().send,
                    onPressed: () async {
                      await _transferMoney();
                    },
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
