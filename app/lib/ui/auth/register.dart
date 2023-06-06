import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../components/custom_app_bar.dart';
import '../main/home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
  }

  late Validator validator;
  final postRequest = PostRequest();
  User? _registerResponse;

  Future<void> registerRequest(
      String email,
      String password,
      String fantasyName,
      String socialReason,
      String cnpj,
      String cellphone,
      String latitude,
      String longitude) async {
    try {
      final body = {
        "razao_social": socialReason,
        "nome_fantasia": fantasyName,
        "cnpj": cnpj,
        "email": email,
        "celular": cellphone,
        "password": password,
        "latitude": latitude,
        "longitude": longitude,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.REGISTER_W_LOCATION, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {
          _registerResponse = response;
          saveUserToPreferences(_registerResponse!);

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

  Future<void> saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toJson();
    await prefs.setString('user', jsonEncode(userData));
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController coPasswordController = TextEditingController();
  final TextEditingController socialReasonController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController fantasyNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    coPasswordController.dispose();
    socialReasonController.dispose();
    cnpjController.dispose();
    cellphoneController.dispose();
    fantasyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    validator = Validator(context: context);

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
                              TextField(
                                controller: socialReasonController,
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
                                  hintText: 'Razão Social',
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
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              TextField(
                                controller: fantasyNameController,
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
                                  hintText: 'Nome Fantasia',
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
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              TextField(
                                controller: cnpjController,
                                inputFormatters: [Masks().cnpjMask()],
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
                                  hintText: 'CNPJ',
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
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              TextField(
                                controller: cellphoneController,
                                inputFormatters: [Masks().cellphoneMask()],
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
                                  hintText: 'Celular',
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
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
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
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
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
                              SizedBox(height: Dimens.marginApplication),
                              TextField(
                                controller: coPasswordController,
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
                                  hintText: 'Confirmar Senha',
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
                              SizedBox(height: Dimens.marginApplication),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Dimens.textSize5,
                                    fontFamily: 'Inter',
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                        'Ao clicar no botão Criar conta, você aceita os'),
                                    TextSpan(
                                        text: ' Termos de uso',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: Dimens.textSize5,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                                context, "/ui/pdf_viewer");
                                          }),
                                    TextSpan(text: ' do aplicativo.'),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: Dimens.marginApplication),
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              OwnerColors.colorPrimary),
                                    ),
                                    onPressed: () {
                                      if (!validator.validateGenericTextField(
                                          socialReasonController.text,
                                          "Razão social")) return;
                                      if (!validator.validateGenericTextField(
                                          fantasyNameController.text,
                                          "Nome fantasia")) return;
                                      if (!validator.validateCNPJ(
                                          cnpjController.text)) return;
                                      if (!validator.validateCellphone(
                                          cellphoneController.text)) return;
                                      if (!validator.validateEmail(
                                          emailController.text)) return;
                                      if (!validator.validatePassword(
                                          passwordController.text)) return;
                                      if (!validator.validateCoPassword(
                                          passwordController.text,
                                          coPasswordController.text)) return;

                                      registerRequest(
                                          emailController.text,
                                          passwordController.text,
                                          fantasyNameController.text,
                                          socialReasonController.text,
                                          cnpjController.text,
                                          cellphoneController.text,
                                          "432432432",
                                          "432423423");
                                    },
                                    child: Text(
                                      "Criar conta",
                                      style: TextStyle(
                                          fontSize: Dimens.textSize8,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none),
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
