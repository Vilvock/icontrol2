import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:icontrol/ui/main/plans.dart';

import '../../config/preferences.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../components/custom_app_bar.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  State<Plan> createState() => _Plan();
}

class _Plan extends State<Plan> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();

  Future<Map<String, dynamic>> loadPlan() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PLAN, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadHistoryUserPlans() async {
    try {
      final body = {
        "id_user": Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(
          Links.LIST_HISTORY_USER_PLANS, body);

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
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Meu plano",
        ),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: /*FutureBuilder<List<Map<String, dynamic>>>(
              future: loadProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  final response = Product.fromJson(snapshot.data![0]);

                  return */
                Stack(children: [
              SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.all(Dimens.marginApplication),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   "Resumo",
                            //   style: TextStyle(
                            //     fontFamily: 'Inter',
                            //     fontSize: Dimens.textSize6,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // SizedBox(height: Dimens.minMarginApplication),
                            Text(
                              "Plano atual",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize4,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            FutureBuilder<Map<String, dynamic>>(
                              future: loadPlan(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final response =
                                      User.fromJson(snapshot.data!);
                                  // {
                                  // "plano_id": 2,
                                  // "plano_nome": "Mensal",
                                  // "tempo_total_dias": 30,
                                  // "tempo_restante_dias": 17,
                                  // "tempo_restante_horas": 7,
                                  // "tempo_restante_minutos": 3,
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(response.plano_nome,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: Dimens.textSize6,
                                              color: OwnerColors.colorPrimary,
                                            )),

                                        SizedBox(height: Dimens.minMarginApplication),
                                        Text("Dais restantes: " + response.tempo_restante_dias.toString(),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: Dimens.textSize4,
                                              color: OwnerColors.colorPrimaryDark,
                                            )),
                                      ]);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return Styles().defaultLoading;
                              },
                            ),
                            SizedBox(height: Dimens.marginApplication),
                            Styles().div_horizontal,
                            SizedBox(height: Dimens.marginApplication),
                            // Text(
                            //   "Planos",
                            //   style: TextStyle(
                            //     fontFamily: 'Inter',
                            //     fontSize: Dimens.textSize6,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // SizedBox(height: 4),
                            Text(
                              "Você pode selecionar qualquer um dos planos para receber vantagens, como acesso a ferramentas vip!",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: Dimens.marginApplication),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: Styles().styleDefaultButton,
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/ui/plans");
                                  },
                                  child: Text(
                                    "Mostrar planos",
                                    style: Styles().styleDefaultTextButton,
                                  )),
                            ),

                            SizedBox(height: Dimens.marginApplication),
                            Styles().div_horizontal,
                            SizedBox(height: Dimens.marginApplication),
                            Text(
                              "Histórico recente de planos",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            // {
                            //   "id": 7,
                            //   "data": "04/05/2023",
                            //   "hora": "09:22",
                            //   "tipo_pagamento": "Cartão de crédito",
                            //   "valor": " R$ 10,00",
                            //   "status": "Aprovado"
                            // },
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: loadHistoryUserPlans(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final response =
                                          User.fromJson(snapshot.data![index]);

                                      return InkWell(
                                          onTap: () => {},
                                          child: Card(
                                            elevation:
                                                Dimens.minElevationApplication,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(Dimens
                                                      .minRadiusApplication),
                                            ),
                                            margin: EdgeInsets.all(
                                                Dimens.minMarginApplication),
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                  Dimens.paddingApplication),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Container(
                                                  //     margin: EdgeInsets.only(
                                                  //         right: Dimens
                                                  //             .minMarginApplication),
                                                  //     child: ClipRRect(
                                                  //         borderRadius: BorderRadius
                                                  //             .circular(Dimens
                                                  //                 .minRadiusApplication),
                                                  //         child: Image.network(
                                                  //           ApplicationConstant
                                                  //                   .URL_PRODUCT_PHOTO +
                                                  //               response
                                                  //                   .url_foto
                                                  //                   .toString(),
                                                  //           height: 90,
                                                  //           width: 90,
                                                  //           errorBuilder: (context,
                                                  //                   exception,
                                                  //                   stackTrack) =>
                                                  //               Icon(
                                                  //                   Icons.error,
                                                  //                   size: 90),
                                                  //         ))),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "nome plano",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens
                                                                .textSize5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Dimens
                                                                .minMarginApplication),
                                                        Text(
                                                          Strings
                                                              .littleLoremIpsum,
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens
                                                                .textSize4,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Dimens
                                                                .minMarginApplication),
                                                        Text(
                                                          "valor",
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens
                                                                .textSize6,
                                                            color: OwnerColors
                                                                .darkGreen,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return Styles().defaultLoading;
                              },
                            ),
                          ],
                        ))
                  ],
                ),
              )),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(Dimens.marginApplication),
                      child: ElevatedButton(
                          style: Styles().styleDefaultButton,
                          onPressed: () {},
                          child: Text(
                            "Mostrar histórico completo",
                            style: Styles().styleDefaultTextButton,
                          )),
                    ),
                  ])
            ])));
    /*     } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center( child: CircularProgressIndicator());
              },
            )));*/
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      _isLoading = false;
    });
  }
}
