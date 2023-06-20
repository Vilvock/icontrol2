import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../config/application_messages.dart';
import '../../../../../config/preferences.dart';
import '../../../../../global/application_constant.dart';
import '../../../../../model/fleet.dart';
import '../../../../../model/payment.dart';
import '../../../../../model/user.dart';
import '../../../../../res/dimens.dart';
import '../../../../../res/owner_colors.dart';
import '../../../../../res/strings.dart';
import '../../../../../res/styles.dart';
import '../../../../../web_service/links.dart';
import '../../../../../web_service/service_response.dart';
import '../../../../components/custom_app_bar.dart';

class Fleets extends StatefulWidget {
  const Fleets({Key? key}) : super(key: key);

  @override
  State<Fleets> createState() => _Fleets();
}

class _Fleets extends State<Fleets> {
  bool _isLoading = false;

  final postRequest = PostRequest();


  Future<List<Map<String, dynamic>>> listFleets(String idCompany, String idEmployee) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_FLEETS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Fleet.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteFleet(String idFleet) async {
    try {
      final body = {
        "id_frota": idFleet,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_FLEET, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Fleet.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> updateSequence(String idFleet, String type) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_frota": idFleet,
        "tipo": type,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.UPDATE_SEQUENCE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Fleet.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  ///////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(title: "Frotas", isVisibleBackButton: true, isVisibleFleetAddButton: true),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: listFleets("", ""),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // final response = Product.fromJson(snapshot.data![0]);

                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
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
