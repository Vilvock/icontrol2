import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icontrol/res/styles.dart';
import 'package:lottie/lottie.dart';
import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../config/validator.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/employee.dart';
import '../../../../model/user.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../../components/alert_dialog_generic.dart';
import '../../../components/custom_app_bar.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _Employees();
}

class _Employees extends State<Employees> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();


  Future<List<Map<String, dynamic>>> verifyTokenRegister(String token) async {
    try {
      final body = {
        "token_cadastro": token
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.VERIFY_TOKEN_REGISTER, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Employee.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listEmployees(String idCompany) async {
    try {
      final body = {
        "id_empresa": idCompany,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_EMPLOYEES, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Employee.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listIdEmployee(String idCompany, String idEmployee) async {
    try {
      final body = {
        "id_empresa": idCompany,
        "id_funcionario": idEmployee,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_ID_EMPLOYEE, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Employee.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> changeStatusEmployee(String idCompany, String idEmployee) async {
    try {
      final body = {
        "id_empresa": idCompany,
        "id_funcionario": idEmployee,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.UPDATE_STATUS_EMPLOYEE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Employee.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteEmployee(String idCompany, String idEmployee) async {
    try {
      final body = {
        "id_empresa": idCompany,
        "id_funcionario": idEmployee,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_EMPLOYEE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Employee.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listEmployeesByToken(String token) async {
    try {
      final body = {
        "token_cadastro": token,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_EMPLOYEES_TOKEN, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Employee.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> completeRegister(String token, String pass) async {
    try {
      final body = {
        "token_cadastro": token,
        "password": pass,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.REGISTER_EMPLOYEE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Employee.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: "Meus funcionários", isVisibleBackButton: true, isVisibleAddButton: true,),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: listEmployees(Preferences.getUserData()!.id_empresa.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final responseItem = Employee.fromJson(snapshot.data![0]);

              if (responseItem.rows != 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final response =  Employee.fromJson(snapshot.data![index]);

                    return InkWell(
                        onTap: () => {
                          // Navigator.pushNamed(
                          //     context, "/ui/product_detail",
                          //     arguments: {
                          //       "id_product": response.id_produto,
                          //     })
                        },
                        child: Card(
                          elevation: Dimens.minElevationApplication,
                          color: Colors.white,
                          margin: EdgeInsets.all(Dimens.minMarginApplication),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Dimens.minRadiusApplication),
                          ),
                          child: Container(
                            padding:
                            EdgeInsets.all(Dimens.paddingApplication),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        right: Dimens.minMarginApplication),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimens.minRadiusApplication),
                                        child: Image.network(
                                          ApplicationConstant
                                              .URL_AVATAR +
                                              response.avatar.toString(),
                                          height: 90,
                                          width: 90,
                                          errorBuilder: (context, exception,
                                              stackTrack) =>
                                              Image.asset(
                                                'images/default.png',
                                                height: 90,
                                                width: 90,
                                              ),
                                        ))),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        response.nome,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                          Dimens.minMarginApplication),
                                      Text(
                                        response.email + "\n" + response.celular,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize4,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                          Dimens.minMarginApplication),
                                      Styles().div_horizontal,
                                      SizedBox(
                                          height:
                                          Dimens.minMarginApplication),
                                      Container(
                                          child: IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        child: Wrap(
                                                          direction: Axis.horizontal,
                                                          alignment: WrapAlignment.center,
                                                          crossAxisAlignment:
                                                          WrapCrossAlignment.center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(
                                                                  right: Dimens
                                                                      .minMarginApplication),
                                                              child: Icon(
                                                                  size: 20,
                                                                  Icons.edit_note_outlined),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () => {


                                                                },
                                                                child: Text(
                                                                  "Editar",
                                                                  style: TextStyle(
                                                                    fontFamily: 'Inter',
                                                                    fontSize:
                                                                    Dimens.textSize4,
                                                                    color: Colors.black,
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      )),
                                                  Container(
                                                    child: Styles().div_vertical,
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                        child: Wrap(
                                                          direction: Axis.horizontal,
                                                          alignment: WrapAlignment.center,
                                                          crossAxisAlignment:
                                                          WrapCrossAlignment.center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(
                                                                  right: Dimens
                                                                      .minMarginApplication),
                                                              child: Icon(
                                                                  size: 20,
                                                                  Icons.delete_outline),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () => {
                                                                  showModalBottomSheet<
                                                                      dynamic>(
                                                                    isScrollControlled:
                                                                    true,
                                                                    context: context,
                                                                    shape: Styles()
                                                                        .styleShapeBottomSheet,
                                                                    clipBehavior: Clip
                                                                        .antiAliasWithSaveLayer,
                                                                    builder:
                                                                        (BuildContext
                                                                    context) {
                                                                      return GenericAlertDialog(
                                                                          title: Strings
                                                                              .attention,
                                                                          content:
                                                                          "Tem certeza que deseja remover este produto dos favoritos?",
                                                                          btnBack:
                                                                          TextButton(
                                                                              child:
                                                                              Text(
                                                                                Strings.no,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Inter',
                                                                                  color: Colors.black54,
                                                                                ),
                                                                              ),
                                                                              onPressed:
                                                                                  () {
                                                                                Navigator.of(context).pop();
                                                                              }),
                                                                          btnConfirm:
                                                                          TextButton(
                                                                              child:
                                                                              Text(Strings.yes),
                                                                              onPressed: () {
                                                                                // deleteEmployee(idCompany, response.id.toString());
                                                                                Navigator.of(context).pop();
                                                                              }));
                                                                    },
                                                                  )
                                                                },
                                                                child: Text(
                                                                  "Remover",
                                                                  style: TextStyle(
                                                                    fontFamily: 'Inter',
                                                                    fontSize:
                                                                    Dimens.textSize4,
                                                                    color: Colors.black,
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              )))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                );
              } else {
                return Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Lottie.network(
                                  height: 160,
                                  'https://assets3.lottiefiles.com/private_files/lf30_cgfdhxgx.json')),
                          SizedBox(height: Dimens.marginApplication),
                          Text(
                            Strings.empty_list,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: Dimens.textSize5,
                              color: Colors.black,
                            ),
                          ),
                        ]));
              }
            } else if (snapshot.hasError) {
              return Styles().defaultErrorRequest;
            }
            return Styles().defaultLoading;
          },
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      _isLoading = false;
    });
  }
}
