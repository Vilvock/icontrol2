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
import 'cart.dart';
import 'favorites.dart';
import 'main_menu.dart';
import 'orders.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    ContainerHome(),
    Cart(),
    Orders(),
    Favorites(),
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
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Carrinho',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Meus Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Meus Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Menu Principal',
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

  late final validator;
  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listHighlightsRequest() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "qtd_lista": 0,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_HIGHLIGHTS, body);

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

final List<Widget> carouselItems = [
  CarouselItemBuilder(image: 'images/banner1_image.jpg'),
  CarouselItemBuilder(image: 'images/banner2_image.jpg'),
];

class CarouselItemBuilder extends StatelessWidget {
  final String image;

  const CarouselItemBuilder({Key? key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.minRadiusApplication),
        ),
        margin: EdgeInsets.all(Dimens.minMarginApplication),
        child: Container(
          /*width: MediaQuery.of(context).size.width * 0.90,*/
          child: Image.asset(
            image,
          ),
        ),
      ),
    );
  }
}

final List<Widget> gridlItems = [
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
  GridItemBuilder(image: ''),
];

class GridItemBuilder extends StatelessWidget {
  final String image;

  const GridItemBuilder({Key? key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.minRadiusApplication),
        ),
        margin: EdgeInsets.all(Dimens.minMarginApplication),
        child: Container(
            child: Column(
          children: [
            Container(
                width: double.infinity,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimens.minRadiusApplication),
                        topRight: Radius.circular(Dimens.minRadiusApplication)),
                    child: Image.asset(
                      fit: BoxFit.fitWidth,
                      'images/person.jpg',
                      height: 140,
                    ))),
            SizedBox(height: Dimens.minMarginApplication),
            Container(
              padding: EdgeInsets.all(Dimens.minPaddingApplication),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmoothStarRating(
                      allowHalfRating: true,
                      onRated: (v) {},
                      starCount: 5,
                      rating: 2,
                      size: 16.0,
                      isReadOnly: true,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                      spacing: 0.0),
                  SizedBox(height: Dimens.minMarginApplication),
                  Text(
                    Strings.longLoremIpsum,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: Dimens.textSize5,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: Dimens.marginApplication),
                  Text(
                    "50,00",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: Dimens.textSize6,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
