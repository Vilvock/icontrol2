import 'package:flutter/material.dart';
import 'package:icontrol/res/styles.dart';

import '../../config/preferences.dart';
import '../../res/dimens.dart';
import '../../res/strings.dart';
import '../auth/login.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            // Expanded(
            Material(
                elevation: Dimens.elevationApplication,
                child: Container(
                  padding: EdgeInsets.all(Dimens.paddingApplication),
                  color: Colors.black12,
                  child: Row(
                    children: [
                      Container(
                        margin:
                        EdgeInsets.only(right: Dimens.marginApplication),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/person.jpg'),
                          radius: 32,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem Ipsum Nome",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "email@email.com.br",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                            color: Colors.black38, size: 18,),
                        onPressed: () =>
                        {Navigator.pushNamed(context, "/ui/profile")},
                      )
                    ],
                  ),
                )),
            GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Histórico de pagamentos",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "Visualize pagamentos recentes",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/ui/user_addresses");
                }),


            Styles().div_vertical,

            GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Equipamentos",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "Gerencie Equipamentos",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/ui/user_addresses");
                }),

            Styles().div_vertical,

            GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Funcionários",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "Gerencie seus Funcionários",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {Navigator.pushNamed(context, "/ui/categories");}
            ),

            Styles().div_vertical,

            GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "FAQ",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "Descubra Informações úteis",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {}),


            Styles().div_vertical,

            GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Desativar conta",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "Desative completamente todas as funções da sua conta",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {}),


            Styles().div_vertical,

            GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sair",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "Deslogar desta conta",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GenericAlertDialog(
                          title: Strings.attention,
                          content: Strings.logout,
                          btnBack: TextButton(
                              child: Text(Strings.no),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          btnConfirm: TextButton(
                              child: Text(Strings.yes),
                              onPressed: () async {

                                await Preferences.init();
                                Preferences.clearUserData();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                    ModalRoute.withName("/ui/login"));

                              }));
                    },
                  );
                }),


            Styles().div_vertical,
          ],
        ),
      ),
    );
  }
}
