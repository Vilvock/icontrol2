import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/res/styles.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../config/preferences.dart';
import '../../global/application_constant.dart';
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
  List<Widget> _widgetOptions = [
    ContainerHome(),
    TiresControl(),
    Plan(),
    Search(),
    MainMenu()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
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

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomNavBar({this.currentIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: Dimens.elevationApplication,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: OwnerColors.colorPrimary,
      selectedItemColor: OwnerColors.colorAccent,
      unselectedItemColor: OwnerColors.lightGrey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: Strings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tire_repair),
          label: Strings.tire,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shield_outlined),
          label: Strings.plan,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: Strings.search,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: Strings.menu,
        ),
      ],
    );
  }
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _ContainerHomeState extends State<ContainerHome> {
  bool _isLoading = false;
  int _pageIndex = 0;
  SampleItem? selectedMenu;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Início",
        isVisibleBackButton: false,
        isVisibleSearchButton: true,
        isVisibleNotificationsButton: true,
        isVisibleAddButton: true,
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
                        padding: EdgeInsets.all(Dimens.minPaddingApplication),
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
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimens.radiusApplication),
                                      ),
                                      margin: EdgeInsets.all(
                                          Dimens.minMarginApplication),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            Dimens.paddingApplication),
                                        child: Text("dsda"),
                                      ),
                                    );
                                  },
                                ),
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.70),
                              ),
                              Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Adicionar card",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize6,
                                      color: OwnerColors.colorPrimary,
                                    ),
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
