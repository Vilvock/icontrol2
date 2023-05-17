import 'package:flutter/material.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../components/custom_app_bar.dart';
import '../components/progress_hud.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _Cart();
}

class _Cart extends State<Cart> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Carrinho", isVisibleBackButton: false),
        body: ProgressHUD(
            inAsyncCall: _isLoading,
            valueColor: AlwaysStoppedAnimation<Color>(OwnerColors.colorPrimary),
            child: Container(
                height: double.infinity,
                child: Stack(children: [
                  ListView.builder(
                    padding: EdgeInsets.only(bottom: 300),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              Dimens.minRadiusApplication),
                        ),
                        margin: EdgeInsets.all(Dimens.minMarginApplication),
                        child: Container(
                          padding: EdgeInsets.all(Dimens.paddingApplication),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      right: Dimens.minMarginApplication),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimens.minRadiusApplication),
                                      child: Image.asset(
                                        'images/person.jpg',
                                        height: 90,
                                        width: 90,
                                      ))),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Strings.shortLoremIpsum,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize6,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                        height: Dimens.minMarginApplication),
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
                                      "R\$ 50,00",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize6,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                        height: Dimens.minMarginApplication),
                                    Divider(
                                      color: Colors.black12,
                                      height: 2,
                                      thickness: 1.5,
                                    ),
                                    SizedBox(
                                        height: Dimens.minMarginApplication),
                                    IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            Icon(size: 20,Icons.favorite_border_outlined),
                                            Text(
                                              "Mover para os favoritos",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize4,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: Dimens.minMarginApplication),
                                            VerticalDivider(
                                              color: Colors.black12,
                                              width: 2,
                                              thickness: 1.5,
                                            ),
                                            SizedBox(width: Dimens.minMarginApplication),

                                            Icon(size: 20,Icons.delete_outline),
                                            Text(
                                              "Remover",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: Dimens.textSize4,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Dimens.minRadiusApplication),
                          ),
                          margin: EdgeInsets.all(Dimens.minMarginApplication),
                          child: Container(
                            padding: EdgeInsets.all(Dimens.paddingApplication),
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Subtotal",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize5,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "-- , --",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize5,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize6,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "-- , --",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize6,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              Divider(
                                color: Colors.black12,
                                height: 2,
                                thickness: 1.5,
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              OwnerColors.colorPrimary),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/ui/method_payment");
                                    },
                                    child: Text(
                                      "Escolher método de pagamento",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: Dimens.textSize8,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none),
                                    )),
                              ),
                            ]),
                          ))
                    ],
                  )
                ]))));
  }
}
