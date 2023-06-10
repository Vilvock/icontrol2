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

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({Key? key}) : super(key: key);

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {

  late Validator validator;
  final postRequest = PostRequest();

  @override
  void initState() {
    validator = Validator(context: context);
    super.initState();
  }

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
                                      SizedBox(height: Dimens.marginApplication),
                                      TextField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: OwnerColors.colorPrimary,
                                                width: 1.5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.0),
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
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: Dimens.marginApplication),
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: Styles().styleDefaultButton,
                                            onPressed: () {
                                              if (!validator.validateEmail(
                                                  emailController.text)) return;

                                              Navigator.pushNamed(context, "/ui/verify_token");

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
