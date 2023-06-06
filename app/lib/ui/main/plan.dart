import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../global/application_constant.dart';
import '../../res/owner_colors.dart';
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

  Future<List<Map<String, dynamic>>> listOrders() async {
    try {
      final body = {
        "id_user": /*await Preferences.getUserData()!.id*/"6",
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_NOTIFICATIONS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Meu plano", isVisibleBackButton: false),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: listOrders(),
              builder: (context, snapshot) {

                  return CircularProgressIndicator();

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
