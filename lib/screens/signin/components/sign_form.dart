// ignore_for_file: cancel_subscriptions

import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ntesco_smart_monitoring/components/change_language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/auth.dart';
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import 'package:ntesco_smart_monitoring/sizeconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  LoginRequestModel? model = new LoginRequestModel();
  String? username;
  String? password;
  bool _isObscure = true;
  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    checkConnectivity(null);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) => checkConnectivity(result));
  }

  Future<void> checkConnectivity(ConnectivityResult? result) async {
    Util.checkConnectivity(result, (status) {
      setState(() => isOnline = status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          usernameTextFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          passwordTextFormField(),
          SizedBox(height: getProportionateScreenHeight(50)),
          DefaultButton(
            text: "login.signin_button".tr(),
            press: () async => submitLogin(),
            height: 40,
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChangeLanguage(),
              GestureDetector(
                onTap: () => Util.showNotification(context, null, "Đang cập nhật tính năng...", ContentType.help, 3),
                child: Text(
                  "login.forgot_password_button".tr(),
                  style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500, fontSize: 15),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  Widget usernameTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => username = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "validation.required".tr();
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "login.username_label".tr(),
        labelStyle: TextStyle(color: kPrimaryColor, fontSize: 22, fontWeight: FontWeight.w700),
        hintText: "login.username_hint".tr(),
        hintStyle: TextStyle(color: Color(0xFF989eb1), fontSize: 15, fontWeight: FontWeight.w400),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset("assets/icons/User.svg", height: getProportionateScreenWidth(18)),
        ),
        isDense: true,
      ),
    );
  }

  Widget passwordTextFormField() {
    print(password);
    return TextFormField(
      obscureText: _isObscure,
      onSaved: (newValue) => password = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty)
          return "validation.required".tr();
        else
          return null;
      },
      style: TextStyle(letterSpacing: 2, fontSize: 20),
      decoration: InputDecoration(
        labelText: "login.password_label".tr(),
        labelStyle: TextStyle(color: kPrimaryColor, fontSize: 22, letterSpacing: 0, fontWeight: FontWeight.w700),
        hintText: "login.password_hint".tr(),
        hintStyle: TextStyle(color: Color(0xFF989eb1), fontSize: 15, letterSpacing: 0, fontWeight: FontWeight.w400),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset("assets/icons/Lock.svg", height: getProportionateScreenWidth(18)),
        ),
        isDense: true,
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off, size: 25),
          color: kPrimaryColor,
          onPressed: () => setState(() => _isObscure = !_isObscure),
        ),
      ),
    );
  }

  Future<void> submitLogin() async {
    if (_formKey.currentState!.validate()) {
      if (isOnline == false)
        Util.showNotification(context, null, "Vui lòng kiểm tra kết nối internet của thiết bị của bạn...", ContentType.warning, 2);
      else {
        _formKey.currentState!.save();
        ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");

        model!.username = username!.trim().toLowerCase();
        model!.password = password!.trim();

        await funcLogin(model).then((data) async {
          await Future.delayed(Duration(milliseconds: 500));
          Util.hideKeyboard(context);
          if (data.accessToken!.isNotEmpty) {
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            ProgressHud.of(context)?.showSuccessAndDismiss(text: "Thành công");
            await Future.delayed(Duration(milliseconds: 300));
            _prefs.setBool("ISLOGGEDIN", true);
            _prefs.setString('USER_CURRENT', data.toJson());
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else {
            ProgressHud.of(context)?.dismiss();
            Util.showNotification(context, null, data.errorDescription.toString(), ContentType.failure, 3);
          }
        }).catchError((error, stackTrace) {
          print(error);
          print(stackTrace);
          ProgressHud.of(context)?.dismiss();
          Util.showNotification(context, null, "Có lỗi xảy ra trong quá trình đăng nhập. Chi tiết: $error", ContentType.failure, 3);
        });
      }
    }
  }
}
