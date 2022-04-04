import 'dart:convert';

import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<LoginResponseModel> funcLogin(LoginRequestModel? loginRequestModel) async {
  String url = "https://$endPoint/NNqQth3VQhm7ZY3";
  var body = loginRequestModel!.toJson();
  final response =
      await http.post(Uri.parse(url), headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded'}, body: body);
  if (response.statusCode == 200 || response.statusCode == 400) {
    return LoginResponseModel.fromJson(
      json.decode(response.body),
    );
  } else {
    throw Exception('Failed to load data!');
  } 
}

Future<bool> funcLogOut() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  await preferences.setBool('ViewFirstTime', true);
  return true;
}
