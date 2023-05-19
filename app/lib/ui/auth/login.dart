import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/config/validator.dart';
import 'package:icontrol/global/application_constant.dart';
import 'package:icontrol/model/user.dart';
import 'package:icontrol/web_service/service_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../components/custom_app_bar.dart';
import '../main/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  late Validator validator;
  final postRequest = PostRequest();
  User? _loginResponse;

  Future<void> loginRequest(String email, String password) async {
    try {
      final body = {
        "email": email,
        "password": password,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOGIN, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() async {
          _loginResponse = response;

          await Preferences.setUserData(_loginResponse);
          await Preferences.setLogin(true);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              ModalRoute.withName("/ui/home"));
        });
      } else {
        ApplicationMessages(context: context).showMessage(response.msg);
      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validator = Validator(context: context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(isVisibleBackButton: true),
      body: Container(
        margin: EdgeInsets.all(Dimens.minMarginApplication),
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(Dimens.paddingApplication),
                    child: Center(
                      child: Image.asset(
                        'images/main_logo_1.png',
                        height: 120,
                      ),
                    ),
                  ),
                  Card(
                      elevation: Dimens.minElevationApplication,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimens.minRadiusApplication),
                      ),
                      margin: EdgeInsets.all(Dimens.minMarginApplication),
                      child: Container(
                        padding: EdgeInsets.all(Dimens.paddingApplication),
                        child: Column(children: [
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: OwnerColors.colorPrimary,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'E-mail',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.radiusApplication),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(
                                  Dimens.textFieldPaddingApplication),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimens.textSize5,
                            ),
                          ),
                          SizedBox(height: Dimens.marginApplication),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: OwnerColors.colorPrimary,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'Senha',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.radiusApplication),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(
                                  Dimens.textFieldPaddingApplication),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimens.textSize5,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimens.minMarginApplication),
                            width: double.infinity,
                            child: Text(
                              "Esqueceu sua senha?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Dimens.textSize5,
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: Dimens.marginApplication),
                            width: double.infinity,
                            child: ElevatedButton(
                                style: Styles().styleDefaultButton,
                                onPressed: () async {
                                  if (!validator.validateEmail(
                                      emailController.text)) return;
                                  // if (!validator.validatePassword(passwordController.text)) return;
                                  await Preferences.init();
                                  loginRequest(emailController.text,
                                      passwordController.text);
                                },
                                child: Text(
                                  "Login",
                                  style: Styles().styleDefaultTextButton,
                                )),
                          ),
                        ]),
                      )),
                  Expanded(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: GestureDetector(
                            child: Text(
                              "Ainda não possui uma conta? Entre aqui",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Dimens.textSize5,
                                fontFamily: 'Inter',
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, "/ui/register");
                            })),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
