// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';

class Body extends StatefulWidget {
  final int id;
  Body({Key? key, required this.id}) : super(key: key);

  @override
  _BodyPageState createState() => new _BodyPageState(id);
}

class _BodyPageState extends State<Body> {
  final int id;

  _BodyPageState(this.id);

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
          children: [
            Container(
              child: TopHeaderSub(
                title: "menu.dexuat".tr(),
                subtitle: "menu.dexuat_detai_title".tr(),
                buttonRight: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () => null,
                  child: Stack(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      Icon(Ionicons.filter_circle_outline,
                          color: kPrimaryColor, size: 40.0)
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text("s"),
            )
          ],
        ),
      ),
    );
  }
}
