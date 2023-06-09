import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/res/dimens.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isVisibleBackButton;
  bool isVisibleAddButton;
  bool isVisibleNotificationsButton;
  bool isVisibleSearchButton;

  CustomAppBar(
      {this.title: "",
      this.isVisibleBackButton = false,
      this.isVisibleAddButton = false,
      this.isVisibleNotificationsButton = false,
      this.isVisibleSearchButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: _returnFavoriteIcon(this.isVisibleAddButton,
          this.isVisibleNotificationsButton, this.isVisibleSearchButton, context),
      automaticallyImplyLeading: this.isVisibleBackButton,
      leading: _returnBackIcon(this.isVisibleBackButton, context),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 10,
      title: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: Dimens.minMarginApplication),
            child: Image.asset(
              'images/main_logo_1.png',
              height: AppBar().preferredSize.height * 0.60,
            ),
          ),
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
      return Container(
          margin: EdgeInsets.only(left: Dimens.minMarginApplication),
          child: FloatingActionButton(
            elevation: Dimens.minElevationApplication,
            mini: true,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
              size: 20,
            ),
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
      bool isVisibleAddButton,
      bool isVisibleNotificationsButton,
      bool isVisibleSearchButton,
      BuildContext context) {
    List<Widget> _widgetList = <Widget>[];

    if (isVisibleAddButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          // do something
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

    if (isVisibleNotificationsButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.notifications_none_sharp,
          color: Colors.black,
        ),
        onPressed: () {

          Navigator.pushNamed(context, "/ui/notifications");
        },
      ));
    }


    return _widgetList;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
