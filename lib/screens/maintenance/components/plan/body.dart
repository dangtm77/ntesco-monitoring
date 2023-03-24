import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _header(context),
            Expanded(
              child: Text('s'),
            )
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return TopHeaderSub(
      title: "maintenance.plan_title".tr(),
      subtitle: "maintenance.plan_subtitle".tr(),
      buttonLeft: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.pop(context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
        ),
      ),
    );
  }
}
