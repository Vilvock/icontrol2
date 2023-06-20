import 'dart:convert';

import 'package:flutter/material.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/employee.dart';
import '../../model/model.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';

class ModelFormAlertDialog extends StatefulWidget {

  final String? id;
  final String? idBrand;
  final String? name;
  final String? status;

  ModelFormAlertDialog({
    Key? key, this.id, this.idBrand, this.name, this.status,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<ModelFormAlertDialog> createState() => _ModelFormAlertDialog();
}

class _ModelFormAlertDialog extends State<ModelFormAlertDialog> {
  late Validator validator;
  bool _isLoading = false;

  bool light = false;

  final postRequest = PostRequest();

  @override
  void initState() {
    validator = Validator(context: context);

    if (widget.id != null) {
      nameController.text = widget.name!;

      if (widget.status == "1") {
        light = true;
      } else {
        light = false;
      }
    }

    super.initState();
  }

  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> saveModel(String idBrand, String name, String status) async {
    try {
      final body = {
        "id_marca": idBrand,
        "nome": name,
        "status": status,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_MODEL, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Model.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> updateModel(String idModel, String name, String status) async {
    try {
      final body = {
        "id_modelo": idModel,
        "nome": name,
        "status": status,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.UPDATE_MODEL, body);

      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Model.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    Dimens.paddingApplication,
                    Dimens.paddingApplication,
                    Dimens.paddingApplication,
                    MediaQuery.of(context).viewInsets.bottom +
                        Dimens.paddingApplication),
                child: Column(
                  children: [
                    Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )),
                    Container(
                      width: double.infinity,
                      child: Text(
                        widget.id != null ?  "Editar Modelo" :"Adicionar Modelo",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize6,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: OwnerColors.colorPrimary, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            hintText: 'Nome',
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
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Dimens.textSize5,
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: Dimens.marginApplication),
                    Styles().div_horizontal,
                    Visibility(visible: widget.id != null, child: Row(children: [
                      Text(
                        "Status (Inativo / Ativo)",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize5,
                          color: Colors.black,
                        ),
                      ),
                      Switch(
                        value: light,
                        onChanged: (bool value) {
                          setState(() {
                            light = value;
                          });
                        },
                      ),
                    ],)),
                    SizedBox(height: Dimens.marginApplication),
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () async {
                          if (!validator.validateGenericTextField(
                              nameController.text, "Nome")) return;

                          setState(() {
                            _isLoading = true;
                          });

                          if (widget.id != null) {
                            //     {
                            //       "id_marca": 1,
                            //   "nome": "testeee",
                            //   "status": 2,
                            //   "token": "12Qge8d3"
                            // }
                            await updateModel(
                                widget.id!,
                                nameController.text.toString(),
                                light ? "1" : "2");
                          } else {
                            //     {
                            //       "id_user": 21,
                            //   "nome": "teste",
                            //   "status": 1,
                            //   "token": "12Qge8d3"
                            // }
                            await saveModel(
                              widget.idBrand.toString(),
                              nameController.text.toString(),
                              "1",);
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: (_isLoading)
                            ? const SizedBox(
                            width: Dimens.buttonIndicatorWidth,
                            height: Dimens.buttonIndicatorHeight,
                            child: CircularProgressIndicator(
                              color: OwnerColors.colorAccent,
                              strokeWidth: Dimens.buttonIndicatorStrokes,
                            ))
                            : Text("Salvar",
                            style: Styles().styleDefaultTextButton),
                      ),
                    ),
                  ],
                ),
              ),
            ]));
  }
}
