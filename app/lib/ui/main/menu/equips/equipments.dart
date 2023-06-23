import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../config/application_messages.dart';
import '../../../../../config/preferences.dart';
import '../../../../../global/application_constant.dart';
import '../../../../../model/payment.dart';
import '../../../../../model/user.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../res/strings.dart';
import '../../../../../res/styles.dart';
import '../../../../../web_service/links.dart';
import '../../../../../web_service/service_response.dart';
import '../../../../model/equipment.dart';
import '../../../components/custom_app_bar.dart';

class Equipments extends StatefulWidget {
  const Equipments({Key? key}) : super(key: key);

  @override
  State<Equipments> createState() => _Equipments();
}

class _Equipments extends State<Equipments> {
  bool _isLoading = false;

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listEquips() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_EQUIPMENTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Equipment.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteEquip(String idEquip) async {
    try {
      final body = {
        "id_equipamento": idEquip,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.DELETE_EQUIPMENT, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Equipment.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(title: "Equipamentos", isVisibleBackButton: true, isVisibleEquipmentAddButton: true, isVisibleFleetButton: true, isVisibleBrandButton: true,),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: listEquips(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // final response = Product.fromJson(snapshot.data![0]);

                      return Stack(children: [
                        SingleChildScrollView(
                            child: Container(
                          padding: EdgeInsets.only(bottom: 100),
                          child: Column(
                            children: [
                              Container(
                                  margin:
                                      EdgeInsets.all(Dimens.marginApplication),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [],
                                  ))
                            ],
                          ),
                        )),
                        // Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisSize: MainAxisSize.max,
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Container(
                        //           margin: EdgeInsets.all(
                        //               Dimens.minMarginApplication),
                        //           width: double.infinity,
                        //           child: Column(children: [
                        //             Container(
                        //                 width: double.infinity,
                        //                 child: ElevatedButton(
                        //                   style:
                        //                       Styles().styleAlternativeButton,
                        //                   onPressed: () {
                        //                     Navigator.pushNamed(
                        //                         context, "/ui/fleets");
                        //                         },
                        //                   child: Text("Frotas",
                        //                       style: Styles()
                        //                           .styleDefaultTextButton),
                        //                 )),
                        //             SizedBox(height: Dimens.marginApplication),
                        //             Container(
                        //                 width: double.infinity,
                        //                 child: ElevatedButton(
                        //                   style:
                        //                       Styles().styleAlternativeButton,
                        //                   onPressed: () {
                        //                     Navigator.pushNamed(
                        //                         context, "/ui/brands");
                        //                   },
                        //                   child: Text("Marcas",
                        //                       style: Styles()
                        //                           .styleDefaultTextButton),
                        //                 )),
                        //           ])),
                        //     ])
                      ]);
                    } else if (snapshot.hasError) {
                      return Styles().defaultErrorRequest;
                    }
                    return Styles().defaultLoading;
                  },
                ))));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;

      _isLoading = false;
    });
  }
}
