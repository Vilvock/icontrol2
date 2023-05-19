import 'dart:convert';

import 'package:flutter/material.dart';

import '../../global/application_constant.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../components/custom_app_bar.dart';
import '../components/progress_hud.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listFavorites() async {
    try {
      final body = {
        "id_user": /*await Preferences.getUserData()!.id*/ "6",
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_NOTIFICATIONS, body);

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
      appBar: CustomAppBar(title: "Pesquisar", isVisibleBackButton: false),
      body: ProgressHUD(
          inAsyncCall: _isLoading,
          valueColor: AlwaysStoppedAnimation<Color>(OwnerColors.colorPrimary),
          child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: listFavorites(), builder: (context, snapshot) {
                    return Container(child: Container());
              }))),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listFavorites();
      _isLoading = false;
    });
  }
}
