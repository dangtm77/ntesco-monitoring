import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Util {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void showNotification(BuildContext context, String? title, String message, ContentType type, int duration) {
    final snackBar = SnackBar(
      duration: Duration(seconds: duration),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title ?? (type == ContentType.failure ? "HỆ THỐNG CẢNH BÁO" : "TRUNG TÂM THÔNG BÁO"),
        message: message,
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future<void> checkConnectivity(ConnectivityResult? result, Function callback) async {
    var status = ((result != null) ? result : (await Connectivity().checkConnectivity()));
    callback((status == ConnectivityResult.wifi || status == ConnectivityResult.mobile));
  }
}
