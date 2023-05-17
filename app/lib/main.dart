// @dart=2.9
import 'package:flutter/material.dart';
import 'package:icontrol/res/owner_colors.dart';
import 'package:icontrol/ui/auth/login.dart';
import 'package:icontrol/ui/auth/register.dart';
import 'package:icontrol/ui/intro/onboarding.dart';
import 'package:icontrol/ui/intro/splash.dart';
import 'package:icontrol/ui/main/checkout_flow/method_payment.dart';
import 'package:icontrol/ui/main/checkout_flow/sucess.dart';
import 'package:icontrol/ui/main/home.dart';
import 'package:icontrol/ui/main/menu/profile.dart';
import 'package:icontrol/ui/utilities/pdf_viewer.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Água da Serra",
    initialRoute:'/ui/splash',
    color: OwnerColors.colorPrimary,
    routes: {
      '/ui/splash': (context) => Splash(),
      '/ui/onboarding': (context) => Onboarding(),
      '/ui/login': (context) => Login(),
      '/ui/register': (context) => Register(),
      '/ui/home': (context) => Home(),
      '/ui/profile': (context) => Profile(),
      '/ui/pdf_viewer': (context) => PdfViewer(),
      '/ui/method_payment': (context) => MethodPayment(),
      '/ui/sucess': (context) => Sucess()


      //lista horizontal
      // Container(
      //   height: 180,
      //   child: ListView.builder(
      //     scrollDirection: Axis.horizontal,
      //     itemCount: /*numbersList.length*/ 2,
      //     itemBuilder: (context, index) {
      //       return Card(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(
      //               Dimens.minRadiusApplication),
      //         ),
      //         margin:
      //             EdgeInsets.all(Dimens.minMarginApplication),
      //         child: Container(
      //           width: MediaQuery.of(context).size.width * 0.80,
      //           padding:
      //               EdgeInsets.all(Dimens.paddingApplication),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    },
  ));
}