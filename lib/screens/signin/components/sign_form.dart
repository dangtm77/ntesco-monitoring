import 'package:bmprogresshud/progresshud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ntesco_smart_monitoring/components/change_language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ntesco_smart_monitoring/core/auth.dart';
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart'; 
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool _isObscure = true;
  LoginRequestModel? requestModel;

  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          buildUsernameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "login.signin_button".tr(),
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");

                requestModel!.username = username!.trim();
                requestModel!.password = password!.trim();

                funcLogin(requestModel).then((data) async {
                  await Future.delayed(Duration(milliseconds: 500));
                  Util.hideKeyboard(context);
                  if (data.accessToken!.isNotEmpty) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    ProgressHud.of(context)
                        ?.showSuccessAndDismiss(text: "Thành công");
                    await Future.delayed(Duration(milliseconds: 300));

                    prefs.setBool("ISLOGGEDIN", true);
                    prefs.setString('USERCURRENT', data.toJson());
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName);
                  } else {
                    ProgressHud.of(context)?.dismiss();

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                        content: Text(data.errorDescription.toString())));
                  }
                });
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChangeLanguage(),
              GestureDetector(
                onTap: () => {},
                child: Text(
                  "login.forgot_password_button".tr(),
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 15),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => username = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "validation.required"
              .tr(args: [("login.username_label".tr())]);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "login.username_label".tr(),
        labelStyle: TextStyle(
            color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w700),
        hintText: "login.username_hint".tr(),
        hintStyle: TextStyle(
            color: Color(0xFF989eb1),
            fontSize: 15,
            fontWeight: FontWeight.w400),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset("assets/icons/User.svg",
              height: getProportionateScreenWidth(18)),
        ),
        isDense: true,
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: _isObscure,
      onSaved: (newValue) => password = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "validation.required"
              .tr(args: [("login.password_label".tr())]);
        } else
          return null;
      },
      style: TextStyle(letterSpacing: 4, fontSize: 20),
      decoration: InputDecoration(
        labelText: "login.password_label".tr(),
        labelStyle: TextStyle(
            color: kPrimaryColor,
            fontSize: 20,
            letterSpacing: 0,
            fontWeight: FontWeight.w700),
        hintText: "login.password_hint".tr(),
        hintStyle: TextStyle(
            color: Color(0xFF989eb1),
            fontSize: 15,
            letterSpacing: 0,
            fontWeight: FontWeight.w400),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset("assets/icons/Lock.svg",
              height: getProportionateScreenWidth(18)),
        ),
        isDense: true,
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            color: kPrimaryColor,
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
      ),
    );
  }
}
