import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icontrol/res/styles.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/strings.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
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
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();
  User? _profileResponse;

  Future<Map<String, dynamic>> loadProfileRequest() async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PROFILE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> disableAccount() async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.DISABLE_ACCOUNT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.init();
        Preferences.clearUserData();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            ModalRoute.withName("/ui/login"));
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg + "\n\n" + Strings.enable_account);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Menu principal",),
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


            Styles().div_horizontal,

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

            Styles().div_horizontal,

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

            Styles().div_horizontal,

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


            Styles().div_horizontal,

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
                onTap: () {

                  showModalBottomSheet<dynamic>(
                    isScrollControlled: true,
                    context: context,
                    shape: Styles().styleShapeBottomSheet,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (BuildContext context) {
                      return GenericAlertDialog(
                          title: Strings.attention,
                          content: Strings.disable_account,
                          btnBack: TextButton(
                              child: Text(Strings.no,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black54,
                                  )),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          btnConfirm: TextButton(
                              child: Text(Strings.yes),
                              onPressed: () {
                                disableAccount();
                              }));
                    },
                  );
                }),


            Styles().div_horizontal,

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
                  showModalBottomSheet<dynamic>(
                    isScrollControlled: true,
                    context: context,
                    shape: Styles().styleShapeBottomSheet,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (BuildContext context) {
                      return GenericAlertDialog(
                          title: Strings.attention,
                          content: Strings.logout,
                          btnBack: TextButton(
                              child: Text(
                                Strings.no,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black54,
                                ),
                              ),
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


            Styles().div_horizontal,
          ],
        ),
      ),
    );
  }
}
