import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../config/application_messages.dart';
import '../../../../../config/preferences.dart';
import '../../../../../global/application_constant.dart';
import '../../../../../model/brand.dart';
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

class Brands extends StatefulWidget {
  const Brands({Key? key}) : super(key: key);

  @override
  State<Brands> createState() => _Brands();
}

class _Brands extends State<Brands> {
  bool _isLoading = false;

  final postRequest = PostRequest();


  Future<Map<String, dynamic>> saveBrand(String name, String status) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "nome": name,
        "status": status,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_BRAND, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Brand.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> updateBrand(String idBrand, String name, String status) async {
    try {
      final body = {
        "id_marca": idBrand,
        "nome": name,
        "status": status,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.UPDATE_BRAND, body);

      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Brand.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listBrands() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_BRANDS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Brand.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteBrand(String idBrand) async {
    try {
      final body = {
        "id_marca": idBrand,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_BRAND, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Brand.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(title: "Marcas", isVisibleBackButton: true, isVisibleBrandAddButton: true),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: listBrands(),
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