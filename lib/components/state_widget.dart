
import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/core/auth.dart';
import 'package:ntesco_smart_monitoring/screens/signin/signin_screen.dart';
import '../constants.dart';
import 'package:easy_localization/easy_localization.dart';

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
            Text("state.error".tr().toUpperCase(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kPrimaryColor)),
            Text("state.error_subtitle".tr(), style: TextStyle(fontSize: 13, color: kSecondaryColor)),
            SizedBox(height: 20),
            Text(
              "$error",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
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
        Text("state.loading".tr().toUpperCase(),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kPrimaryColor)),
        Text("state.loading_subtitle".tr(), style: TextStyle(fontSize: 13, color: kSecondaryColor)),
      ],
    );
  }
}

class NoDataWidget extends StatefulWidget {
  final String message;
  const NoDataWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  _NoDataWidgetState createState() => _NoDataWidgetState(message);
}
class _NoDataWidgetState extends State<NoDataWidget> {
  final String message;
  _NoDataWidgetState(this.message);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
      Center(
          child: Column(children: <Widget>[
        Icon(Icons.warning_amber_rounded, size: 50, color: Colors.redAccent),
        Text("state.nodata".tr().toUpperCase(),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kPrimaryColor)),
        Text("state.nodata_subtitle".tr(), style: TextStyle(fontSize: 13, color: kSecondaryColor)),
      ]))
    ]);
  }
}
