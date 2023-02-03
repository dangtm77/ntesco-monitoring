// ignore_for_file: unnecessary_statements

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/dx/DanhMuc.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/components/create_form.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/dexuat_screen.dart';

class Body extends StatefulWidget {
  final DanhMucModel danhmuc;
  Body({Key? key, required this.danhmuc}) : super(key: key);

  @override
  _BodyPageState createState() => new _BodyPageState(danhmuc);
}

class _BodyPageState extends State<Body> {
  final DanhMucModel danhmuc;
  _BodyPageState(this.danhmuc);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_header(), CreateForm(danhmuc: danhmuc)],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      child: TopHeaderSub(
        title: "phieudexuat.create_title".tr(),
        subtitle: danhmuc.tieuDe.toString(),
        buttonLeft: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pushNamed(context, ListOfDeXuatScreen.routeName),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
          ),
        ),
      ),
    );
  }
}
