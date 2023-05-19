import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../components/progress_hud.dart';
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
      backgroundColor: Colors.white,
      selectedItemColor: OwnerColors.colorPrimary,
      unselectedItemColor: Colors.grey,
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

class _ContainerHomeState extends State<ContainerHome> {
  bool _isLoading = false;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Início", isVisibleBackButton: false, isVisibleSearchButton: true,),
        body: ProgressHUD(
          inAsyncCall: _isLoading,
          valueColor: AlwaysStoppedAnimation<Color>(OwnerColors.colorPrimary),
          child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [],
                  ),
                ),
              )),
        ));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listHighlightsRequest();
      _isLoading = false;
    });
  }

}
