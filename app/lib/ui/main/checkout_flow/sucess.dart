import 'package:flutter/material.dart';

import '../../../res/owner_colors.dart';
import '../../components/custom_app_bar.dart';

class Sucess extends StatefulWidget {
  const Sucess({Key? key}) : super(key: key);

  @override
  State<Sucess> createState() => _Sucess();
}

class _Sucess extends State<Sucess> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:
        CustomAppBar(title: "Sucesso", isVisibleBackButton: false),
        body:
            RefreshIndicator(onRefresh: _pullRefresh, child: Container()));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sending Message"),
      ));
      _isLoading = false;
    });
  }
}
