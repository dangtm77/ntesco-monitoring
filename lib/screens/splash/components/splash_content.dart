import 'package:flutter/material.dart'; 
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        SizedBox(height: 50),
        Image.asset("assets/images/logofull.png", width: getProportionateScreenWidth(190)), 
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
        SizedBox(height: 10),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
