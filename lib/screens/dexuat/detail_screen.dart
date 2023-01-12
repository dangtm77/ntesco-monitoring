// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/components/detail_body.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class DeXuatDetailScreen extends StatelessWidget {
  static String routeName = "/dexuat/detail";

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    SizeConfig().init(context);
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      body: Body(id: int.parse(arguments['id'].toString())),
    );
  }
}
