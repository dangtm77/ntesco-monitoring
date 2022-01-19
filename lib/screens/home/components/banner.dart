import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';

import '../../../size_config.dart';

class HeaderBanner extends StatelessWidget {
  final LoginResponseModel? model;

  const HeaderBanner({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(20), getProportionateScreenWidth(20), getProportionateScreenWidth(20), 0),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(15),
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "hello_message".tr(args: [model!.fullName.toString()]).toString(),
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            WidgetSpan(child: SizedBox(height: 20)),
            TextSpan(text: "welcome_message".tr()),
          ],
        ),
      ),
    );
  }
}
