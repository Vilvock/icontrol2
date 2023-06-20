import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icontrol/res/dimens.dart';
import 'package:icontrol/ui/components/alert_dialog_employee_form.dart';
import 'package:icontrol/ui/main/menu/equips/equipments.dart';

import '../../res/styles.dart';
import 'alert_dialog_brand_form.dart';
import 'alert_dialog_equipments_form.dart';
import 'alert_dialog_model_form.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isVisibleBackButton;
  bool isVisibleModelAddButton;
  bool isVisibleBrandAddButton;
  bool isVisibleFleetAddButton;
  bool isVisibleEquipmentAddButton;
  bool isVisibleEmployeeAddButton;
  bool isVisibleTaskAddButton;
  bool isVisibleNotificationsButton;
  bool isVisibleSearchButton;


  String idBrand;

  CustomAppBar(
      {this.title: "",
        this.idBrand: "",
      this.isVisibleBackButton = false,
      this.isVisibleModelAddButton = false,
      this.isVisibleBrandAddButton = false,
      this.isVisibleFleetAddButton = false,
      this.isVisibleEquipmentAddButton = false,
      this.isVisibleEmployeeAddButton = false,
      this.isVisibleTaskAddButton = false,
      this.isVisibleNotificationsButton = false,
      this.isVisibleSearchButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: _returnFavoriteIcon(
          this.isVisibleModelAddButton,
          this.isVisibleBrandAddButton,
          this.isVisibleFleetAddButton,
          this.isVisibleEquipmentAddButton,
          this.isVisibleEmployeeAddButton,
          this.isVisibleNotificationsButton,
          this.isVisibleSearchButton,
          this.isVisibleTaskAddButton,
          context),
      automaticallyImplyLeading: this.isVisibleBackButton,
      leading: _returnBackIcon(this.isVisibleBackButton, context),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 10,
      title: Row(
        children: [
/*          Container(
            margin: EdgeInsets.only(left: Dimens.minMarginApplication),
            child: Image.asset(
              'images/main_logo_1.png',
              height: AppBar().preferredSize.height * 0.60,
            ),
          ),*/
          Container(
            margin: EdgeInsets.only(left: Dimens.minMarginApplication),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: Dimens.textSize6,
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
      bool isVisibleModelAddButton,
      bool isVisibleBrandAddButton,
      bool isVisibleFleetAddButton,
      bool isVisibleEmployeeAddButton,
      bool isVisibleEquipmentAddButton,
      bool isVisibleNotificationsButton,
      bool isVisibleSearchButton,
      bool isVisibleTaskAddButton,
      BuildContext context) {
    List<Widget> _widgetList = <Widget>[];

    if (isVisibleEmployeeAddButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              shape: Styles().styleShapeBottomSheet,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (BuildContext context) {
                return EmployeeFormAlertDialog();
              });
          if (result == true) {
            Navigator.popUntil(
              context,
              ModalRoute.withName('/ui/home'),
            );
            Navigator.pushNamed(context, "/ui/employees");
          }
        },
      ));
    }

    if (isVisibleTaskAddButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          // final result = await showModalBottomSheet<dynamic>(
          //     isScrollControlled: true,
          //     context: context,
          //     shape: Styles().styleShapeBottomSheet,
          //     clipBehavior: Clip.antiAliasWithSaveLayer,
          //     builder: (BuildContext context) {
          //       return EmployeeFormAlertDialog();}
          // );
          // if(result == true){
          //   Navigator.popUntil(
          //     context,
          //     ModalRoute.withName('/ui/home'),
          //   );
          //   Navigator.pushNamed(context, "/ui/user_addresses");
          // }
        },
      ));
    }

    if (isVisibleBrandAddButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              shape: Styles().styleShapeBottomSheet,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (BuildContext context) {
                return BrandFormAlertDialog();
              });
          if (result == true) {

          }
        },
      ));
    }

    if (isVisibleModelAddButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              shape: Styles().styleShapeBottomSheet,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (BuildContext context) {
                return ModelFormAlertDialog(idBrand: idBrand,);
              });
          if (result == true) {

          }
        },
      ));
    }

    if (isVisibleEquipmentAddButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          final result = await showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              shape: Styles().styleShapeBottomSheet,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (BuildContext context) {
                return EquipmentFormAlertDialog();
              });
          if (result == true) {

          }
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
