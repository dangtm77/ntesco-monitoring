import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(30),
          ),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(100)),
              Image.asset("assets/images/logofull.png", width: 200),
              SizedBox(height: getProportionateScreenHeight(20)),
              SignForm(),
              SizedBox(height: getProportionateScreenHeight(100)),
            ],
          ),
        ),
      ),
    );
  }
}
