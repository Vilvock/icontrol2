import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/res/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/application_messages.dart';
import '../../../config/masks.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import '../../main/home.dart';

class UpdatePasswordToken extends StatefulWidget {
  const UpdatePasswordToken({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordToken> createState() => _UpdatePasswordTokenState();
}

class _UpdatePasswordTokenState extends State<UpdatePasswordToken> {

  late bool _passwordVisible;
  late bool _passwordVisible2;

  bool hasPasswordCoPassword = false;
  bool hasUppercase = false;
  bool hasMinLength = false;
  bool visibileOne = false;
  bool visibileTwo = false;

  bool _isLoading = false;
  User? _profileResponse;

  late Validator validator;
  final postRequest = PostRequest();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController coPasswordController = TextEditingController();


  @override
  void initState() {
    validator = Validator(context: context);

    _passwordVisible = false;
    _passwordVisible2 = false;

    super.initState();
  }


  @override
  void dispose() {

    passwordController.dispose();
    coPasswordController.dispose();
    super.dispose();
  }


  Future<List<Map<String, dynamic>>> updatePasswordByToken(String newPass, String token) async {
    try {
      final body = {
        "password": newPass,
        "token": token
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.UPDATE_PASSWORD_TOKEN, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(isVisibleBackButton: true,),
        body: Container(
            child: Container(
              child: Column(children: [
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(Dimens.minMarginApplication),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimens.paddingApplication),
                              child: Center(
                                child: Image.asset(
                                  'images/main_logo_1.png',
                                  height: 90,
                                ),
                              ),
                            ),
                            Card(
                                elevation: Dimens.minElevationApplication,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimens.radiusApplication),
                                ),
                                margin: EdgeInsets.all(Dimens.minMarginApplication),
                                child: Container(
                                    padding: EdgeInsets.all(Dimens.paddingApplication),
                                    child: Column(children: [
                                      Text(
                                        "Digite uma nova senha e confirme.",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Dimens.textSize5,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      SizedBox(height: Dimens.marginApplication),
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            hasPasswordCoPassword = false;
                                            visibileOne = true;
                                            hasMinLength = passwordController.text.length >= 8;
                                            hasUppercase = passwordController.text
                                                .contains(RegExp(r'[A-Z]'));

                                            hasPasswordCoPassword = coPasswordController.text ==
                                                passwordController.text;

                                            if (hasMinLength && hasUppercase) {
                                              visibileOne = false;
                                            }
                                          });
                                        },
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                // Based on passwordVisible state choose the icon
                                                _passwordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: OwnerColors.colorPrimary,
                                              ),
                                              onPressed: () {
                                                // Update the state i.e. toogle the state of passwordVisible variable
                                                setState(() {
                                                  _passwordVisible = !_passwordVisible;
                                                });
                                              }),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: OwnerColors.colorPrimary, width: 1.5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey, width: 1.0),
                                          ),
                                          hintText: 'Senha',
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(Dimens.radiusApplication),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                          EdgeInsets.all(Dimens.textFieldPaddingApplication),
                                        ),
                                        keyboardType: TextInputType.visiblePassword,
                                        obscureText: !_passwordVisible,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Dimens.textSize5,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Visibility(
                                        visible: passwordController.text.isNotEmpty,
                                        child: Row(
                                          children: [
                                            Icon(
                                              hasMinLength
                                                  ? Icons.check_circle
                                                  : Icons.check_circle,
                                              color: hasMinLength
                                                  ? Colors.green
                                                  : OwnerColors.lightGrey,
                                            ),
                                            Text(
                                              'Deve ter no mínimo 8 carácteres',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: passwordController.text.isNotEmpty,
                                        child: Row(
                                          children: [
                                            Icon(
                                              hasUppercase
                                                  ? Icons.check_circle
                                                  : Icons.check_circle,
                                              color: hasUppercase
                                                  ? Colors.green
                                                  : OwnerColors.lightGrey,
                                            ),
                                            Text(
                                              'Deve ter uma letra maiúscula',
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Dimens.marginApplication),
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            visibileTwo = true;
                                            hasPasswordCoPassword = coPasswordController.text ==
                                                passwordController.text;

                                            if (hasPasswordCoPassword) {
                                              visibileTwo = false;
                                            }
                                          });
                                        },
                                        controller: coPasswordController,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                // Based on passwordVisible state choose the icon
                                                _passwordVisible2
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: OwnerColors.colorPrimary,
                                              ),
                                              onPressed: () {
                                                // Update the state i.e. toogle the state of passwordVisible variable
                                                setState(() {
                                                  _passwordVisible2 = !_passwordVisible2;
                                                });
                                              }),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: OwnerColors.colorPrimary, width: 1.5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey, width: 1.0),
                                          ),
                                          hintText: 'Confirmar Senha',
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(Dimens.radiusApplication),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                          EdgeInsets.all(Dimens.textFieldPaddingApplication),
                                        ),
                                        keyboardType: TextInputType.visiblePassword,
                                        obscureText: !_passwordVisible2,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Dimens.textSize5,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Visibility(
                                        visible: coPasswordController.text.isNotEmpty,
                                        child: Row(
                                          children: [
                                            Icon(
                                              hasPasswordCoPassword
                                                  ? Icons.check_circle
                                                  : Icons.check_circle,
                                              color: hasPasswordCoPassword
                                                  ? Colors.green
                                                  : OwnerColors.lightGrey,
                                            ),
                                            Text(
                                              'As senhas fornecidas são idênticas',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: Dimens.marginApplication),
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: Styles().styleDefaultButton,
                                            onPressed: () {


                                            },
                                            child: Text(
                                                "Avançar",
                                                style: Styles().styleDefaultTextButton
                                            )),
                                      ),
                                    ]))),
                          ],
                        ),
                      ),
                    )),
              ]),
            )));
  }
}
