import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/core/auth.dart';
import 'package:ntesco_smart_monitoring/screens/signin/signin_screen.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import '../constants.dart';
import 'package:easy_localization/easy_localization.dart';

import 'default_button.dart';

class DataErrorWidget extends StatefulWidget {
  final String error;
  const DataErrorWidget({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  _DataErrorWidgetState createState() => _DataErrorWidgetState(error);
}

class _DataErrorWidgetState extends State<DataErrorWidget> {
  final String error;
  _DataErrorWidgetState(this.error);
  @override
  Widget build(BuildContext context) {
    if (error == "401") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Column(children: <Widget>[
            Icon(
              Icons.lock,
              size: 50,
              color: Colors.red,
            ),
            Text("Xác thực tài khoản".toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text("Thời gian hoặc quyền sự dụng đã hết hạn."),
            Text("Vui lòng đăng nhập lại..."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (await funcLogOut()) Navigator.pushNamed(context, SignInScreen.routeName);
              },
              child: const Text(
                'Đăng nhập',
                style: TextStyle(fontSize: 17),
              ),
            ),
            TextButton(onPressed: () => {}, child: Text(""))
          ])),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Column(children: <Widget>[
            Icon(
              Icons.warning_amber_rounded,
              size: 90,
              color: Colors.redAccent,
            ),
            Text("state.error".tr().toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kPrimaryColor)),
            Text("state.error_subtitle".tr(), style: TextStyle(fontSize: 13, color: kSecondaryColor)),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: Text(
                "$error",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            )
          ])),
          // Expanded(
          //   child: ,
          // )
        ],
      );
    }
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new CircularProgressIndicator(
          strokeWidth: 3,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
        new SizedBox(
          height: 10.0,
        ),
        Text("state.loading".tr().toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kPrimaryColor)),
        Text("state.loading_subtitle".tr(), style: TextStyle(fontSize: 15, color: kSecondaryColor)),
      ],
    );
  }
}

class NoDataWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? button;
  const NoDataWidget({Key? key, this.title, this.subtitle, this.button}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("#404#", style: TextStyle(fontSize: 70, fontWeight: FontWeight.w800, color: Colors.redAccent)),
        Text(title ?? "state.nodata".tr().toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.redAccent)),
        Text(subtitle ?? "state.nodata_subtitle".tr(), style: TextStyle(fontSize: 15, color: kSecondaryColor, fontStyle: FontStyle.italic)),
        Visibility(
          visible: button != null,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(width: 100, height: 40, child: button ?? SizedBox(height: 0.0)),
          ),
        )
      ],
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.wifi_off_outlined, size: 100, color: Colors.redAccent),
        Text("state.no_connection".tr().toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.redAccent)),
        Text("state.no_connection_subtitle".tr(), style: TextStyle(fontSize: 15, color: kSecondaryColor, fontStyle: FontStyle.italic)),
      ],
    );
  }
}
