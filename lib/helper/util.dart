import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Util {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void showNotification(BuildContext context, String text, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
        ),
      );
  }

  static Future<void> checkConnectivity(ConnectivityResult? result, Function callback) async {
    var status = ((result != null) ? result : (await Connectivity().checkConnectivity()));
    callback((status == ConnectivityResult.wifi || status == ConnectivityResult.mobile));
  }
}
