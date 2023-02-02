// ignore_for_file: unnecessary_statements

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/list_of_dexuat_screen.dart';

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
                title: "phieudexuat.create_title".tr(),
                subtitle: "phieudexuat.create_subtitle".tr(),
                buttonLeft: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () => Navigator.pushNamed(context, ListOfDeXuatScreen.routeName),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Center(
              child: Text(id.toString()),
            ))
          ],
        ),
      ),
    );
  }
}
