import 'package:flutter/material.dart'; 
import '../../../size_config.dart';
import 'sign_form.dart'; 

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
          child: SingleChildScrollView(
            child: Column( 
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05), 
                Image.asset("assets/images/logo001.png", width: getProportionateScreenWidth(120)), 
                SizedBox(height:5),
                Text("Smart Monitoring",
                  style: TextStyle(
                    color: Color(0xFF989eb1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ), 
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SignForm(), 
                SizedBox(height: getProportionateScreenHeight(20)), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
