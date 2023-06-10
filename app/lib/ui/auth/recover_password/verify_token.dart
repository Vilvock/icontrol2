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

class VerifyToken extends StatefulWidget {
  const VerifyToken({Key? key}) : super(key: key);

  @override
  State<VerifyToken> createState() => _VerifyTokenState();
}

class _VerifyTokenState extends State<VerifyToken> {

  late Validator validator;
  final postRequest = PostRequest();

  @override
  void initState() {
    validator = Validator(context: context);
    super.initState();
  }


  @override
  void dispose() {
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

                                      Container(
                                        margin: EdgeInsets.only(
                                            top: Dimens.marginApplication),
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: Styles().styleDefaultButton,
                                            onPressed: () {

                                              Navigator.pushNamed(context, "/ui/update_password_token");

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
