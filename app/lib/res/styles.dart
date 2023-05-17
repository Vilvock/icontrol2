import 'dart:ui';

import 'package:flutter/material.dart';

import 'dimens.dart';
import 'owner_colors.dart';

class Styles {

  var styleDefaultButton = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.paddingApplication)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.colorPrimary),
  );

  var styleDefaultTextButton = TextStyle(
      fontSize: Dimens.textSize8,
      color: Colors.white,
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);
}
