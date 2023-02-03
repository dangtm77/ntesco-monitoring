import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/models/dx/DanhMuc.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'components/detail_body.dart' as detail;
import 'components/list_body.dart' as list;
import 'components/create_body.dart' as create;

class ListOfDeXuatScreen extends StatelessWidget {
  static String routeName = "/dexuat";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: list.Body());
  }
}

class DetailOfDeXuatScreen extends StatelessWidget {
  static String routeName = "/dexuat/detail";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    int id = int.parse(arguments['id'].toString());
    return Scaffold(drawerScrimColor: Colors.transparent, body: detail.Body(id: id));
  }
}

class CreateDeXuatScreen extends StatelessWidget {
  static String routeName = "/dexuat/create";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    DanhMucModel danhmuc = arguments['danhmuc'];
    return Scaffold(drawerScrimColor: Colors.transparent, body: create.Body(danhmuc: danhmuc));
  }
}
