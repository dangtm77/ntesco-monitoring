import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

const endPoint = "portal-api.ntesco.com";

const kPrimaryColor = Color(0xFF0005493); 

const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Colors.black87;
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

Color colorFirstInCard = Colors.blue;
Color colorSecondInCard = Colors.blueGrey;

// Form Error
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kUsernameNullError = "Vui lòng nhập tên đăng nhập";
const String kEmailNullError = "Vui lòng nhập email của bạn";
const String kInvalidEmailError = "Thông tin email không hợp lệ";
const String kPassNullError = "Vui lòng nhập mật khẩu";
const String kShortPassError = "Mật khẩu này quá ngắn";
const String kMatchPassError = "Mật khẩu này không chính xác";
const String kNamelNullError = "Vui lòng nhập tên của bạn";
const String kPhoneNumberNullError = "Vui lòng nhập số điện thoại của bạn";
const String kAddressNullError = "Vui lòng nhập địa chỉ của bạn";

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
