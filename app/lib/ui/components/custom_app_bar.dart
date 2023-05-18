import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/res/dimens.dart';
import 'package:icontrol/ui/components/alert_dialog_address_form.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isVisibleBackButton;
  bool isVisibleFavoriteButton;
  bool isVisibleAddressButton;
  bool isVisibleSearchButton;

  CustomAppBar(
      {this.title: "",
      this.isVisibleBackButton = false,
      this.isVisibleFavoriteButton = false,
      this.isVisibleAddressButton = false,
      this.isVisibleSearchButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: _returnFavoriteIcon(this.isVisibleFavoriteButton,
          this.isVisibleAddressButton, this.isVisibleSearchButton, context),
      automaticallyImplyLeading: this.isVisibleBackButton,
      leading: _returnBackIcon(this.isVisibleBackButton, context),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 10,
      title: Row(
        children: [
          // Container(
          //   margin: EdgeInsets.only(left: Dimens.minMarginApplication),
          //   child: Image.asset(
          //     'images/main_logo_2.png',
          //     height: AppBar().preferredSize.height,
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(left: Dimens.minMarginApplication),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: Dimens.textSize7,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container? _returnBackIcon(bool isVisible, BuildContext context) {
    if (isVisible) {
      return Container(margin: EdgeInsets.only(left: Dimens.minMarginApplication),
          child: FloatingActionButton(
            elevation: Dimens.minElevationApplication,
            mini: true,
            child: Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20,),
            backgroundColor: Colors.white,
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                SystemNavigator.pop();
              }
            },
          ));
    }

    return null;
  }

  List<Widget> _returnFavoriteIcon(
      bool isVisibleFavoriteButton,
      bool isVisibleAddressButton,
      bool isVisibleSearchButton,
      BuildContext context) {
    List<Widget> _widgetList = <Widget>[];

    if (isVisibleFavoriteButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.favorite_border_outlined,
          color: Colors.black,
        ),
        onPressed: () {
          // do something
        },
      ));
    }

    if (isVisibleAddressButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add_location_alt,
          color: Colors.black,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddressFormAlertDialog();
            },
          );
        },
      ));
    }

    if (isVisibleSearchButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.black,
        ),
        onPressed: () {},
      ));
    }

    return _widgetList;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}