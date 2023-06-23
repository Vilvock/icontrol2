import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/res/styles.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../components/custom_app_bar.dart';
import '../components/dot_indicator.dart';
import 'tires_control.dart';
import 'search.dart';
import 'main_menu.dart';
import 'plan.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    var widgetItems = <Widget>[];

    widgetItems.add(ContainerHome());
    widgetItems.add(TiresControl());
    if (Preferences.getUserData()!.tipo == 1) {
      widgetItems.add(Plan());
    }
    widgetItems.add(MainMenu());

    List<Widget> _widgetOptions = widgetItems;

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar:
          BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}

class ContainerHome extends StatefulWidget {
  const ContainerHome({Key? key}) : super(key: key);

  @override
  State<ContainerHome> createState() => _ContainerHomeState();
}

GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomNavBar({this.currentIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBarItems = <BottomNavigationBarItem>[];

    bottomNavigationBarItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: Strings.home,
    ));
    bottomNavigationBarItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.tire_repair),
      label: Strings.tire,
    ));
    if (Preferences.getUserData()!.tipo == 1) {
      bottomNavigationBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.shield_outlined),
        label: Strings.plan,
      ));
    }
    // bottomNavigationBarItems.add(BottomNavigationBarItem(
    // icon: Icon(Icons.map_outlined),
    // label: Strings.search,
    // ));
    bottomNavigationBarItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: Strings.menu,
    ));
    return BottomNavigationBar(
        key: globalKey,
        elevation: Dimens.elevationApplication,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: OwnerColors.colorPrimary,
        selectedItemColor: OwnerColors.colorAccent,
        unselectedItemColor: OwnerColors.lightGrey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: bottomNavigationBarItems);
  }
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _ContainerHomeState extends State<ContainerHome> {
  bool _isLoading = false;
  int _pageIndex = 0;
  SampleItem? selectedMenu;

  final postRequest = PostRequest();

  @override
  void initState() {
    super.initState();
    saveFcm();
    verifyPlan();
  }

  Future<List<Map<String, dynamic>>> verifyPlan() async {
    try {
      final body = {
        "id_user": Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.VERIFY_PLAN, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);
      if (response.status != "01") {
        var navigationBar = globalKey.currentWidget as BottomNavigationBar;
        navigationBar.onTap!(2);

      } else {}
      ApplicationMessages(context: context).showMessage(response.mensagem);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveFcm() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    try {
      await Preferences.init();
      String? savedFcmToken = await Preferences.getInstanceTokenFcm();
      String? currentFcmToken = await _firebaseMessaging.getToken();
      if (savedFcmToken != null && savedFcmToken == currentFcmToken) {
        print('FCM: não salvou');
        return;
      }

      var _type = "";

      if (Platform.isAndroid) {
        _type = ApplicationConstant.FCM_TYPE_ANDROID;
      } else if (Platform.isIOS) {
        _type = ApplicationConstant.FCM_TYPE_IOS;
      } else {
        return;
      }

      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "type": _type,
        "registration_id": currentFcmToken,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_FCM, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.saveInstanceTokenFcm("token", currentFcmToken!);
        setState(() {});
      } else {}
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Início",
        isVisibleBackButton: false,
        isVisibleSearchButton: true,
        isVisibleNotificationsButton: true,
        isVisibleTaskAddButton: true,
      ),
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Card(
                    elevation: Dimens.minElevationApplication,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimens.radiusApplication),
                    ),
                    margin: EdgeInsets.all(Dimens.minMarginApplication),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Wrap(
                          children: [
                            Column(children: [
                              Row(children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    "Frota 1",
                                    style: Styles().styleDescriptionText,
                                  ),
                                  margin: EdgeInsets.only(
                                      left: Dimens.marginApplication),
                                )),
                                PopupMenuButton<SampleItem>(
                                  initialValue: selectedMenu,
                                  // Callback that sets the selected popup menu item.
                                  onSelected: (SampleItem item) {
                                    setState(() {
                                      selectedMenu = item;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<SampleItem>>[
                                    const PopupMenuItem<SampleItem>(
                                      value: SampleItem.itemOne,
                                      child: Text('Item 1'),
                                    ),
                                    const PopupMenuItem<SampleItem>(
                                      value: SampleItem.itemTwo,
                                      child: Text('Item 2'),
                                    ),
                                    const PopupMenuItem<SampleItem>(
                                      value: SampleItem.itemThree,
                                      child: Text('Item 3'),
                                    ),
                                  ],
                                ),
                              ]),
                              ConstrainedBox(
                                child: SingleChildScrollView(
                                    child: Column(children: [
                                  Image.asset(
                                    'images/random.jpg',
                                    height: 190,
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {

                                      var _statusColor = Colors.blue;

                                      // switch (response.status_pagamento) {
                                      //   case "Pendente":
                                      //     _statusColor = OwnerColors.darkGrey;
                                      //     break;
                                      //   case "Aprovado":
                                      //
                                      //     _statusColor = OwnerColors.colorPrimaryDark;
                                      //     break;
                                      //   case "Rejeitado":
                                      //
                                      //     _statusColor = Colors.yellow[700];
                                      //     break;
                                      //   case "Cancelado":
                                      //
                                      //     _statusColor = Colors.red;
                                      //     break;
                                      //   case "Devolvido":
                                      //
                                      //     _statusColor = OwnerColors.darkGrey;
                                      //     break;
                                      // }

                                      return InkWell(
                                          onTap: () => {
                                            // Navigator.pushNamed(
                                            //     context, "/ui/order_detail",
                                            //     arguments: {
                                            //       "id": response.id,
                                            //     })
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(Dimens.minRadiusApplication),
                                            ),
                                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                                            child: Container(
                                              padding: EdgeInsets.all(Dimens.paddingApplication),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Container(
                                                  //     margin: EdgeInsets.only(
                                                  //         right: Dimens.minMarginApplication),
                                                  //     child: ClipRRect(
                                                  //         borderRadius: BorderRadius.circular(
                                                  //             Dimens.minRadiusApplication),
                                                  //         child: Image.asset(
                                                  //           'images/person.jpg',
                                                  //           height: 90,
                                                  //           width: 90,
                                                  //         ))),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Align(
                                                            alignment: AlignmentDirectional.topStart,
                                                            child: Card(
                                                                color: _statusColor,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(
                                                                      Dimens.minRadiusApplication),
                                                                ),
                                                                child: Container(
                                                                    padding: EdgeInsets.all(
                                                                        Dimens.minPaddingApplication),
                                                                    child: Text(
                                                                      "status",
                                                                      style: TextStyle(
                                                                        fontFamily: 'Inter',
                                                                        fontSize: Dimens.textSize5,
                                                                        color: Colors.white,
                                                                      ),
                                                                    )))),

                                                        SizedBox(height: Dimens.minMarginApplication),
                                                        Text(
                                                          "Equipamento $index",
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens.textSize5,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(height: Dimens.minMarginApplication),
                                                        Text(
                                                          "Data: 00/00/0000",
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens.textSize4,
                                                            color: Colors.black,
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                  )
                                ])),
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.70),
                              ),

                              Container(
                                padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: OwnerColors.colorPrimary,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(Dimens.radiusApplication),
                                        bottomLeft: Radius.circular(Dimens.radiusApplication)
                                    ),

                                  ),
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        size: 24,
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      Text("Adicionar card",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize6,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ))
                            ])
                          ],
                        )),
                  ),
                ]);
          },
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listHighlightsRequest();
      _isLoading = false;
    });
  }
}
