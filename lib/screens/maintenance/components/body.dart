import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import '../plan_screen.dart';

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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MenuOption(
                          title: "Kế hoạch bảo trì",
                          subtitle: "Maintenance Plan",
                          iconData: Ionicons.calendar_outline,
                          selected: true,
                          action: () => Navigator.pushNamed(context, MaintenancePlanScreen.routeName),
                          //action: () => Navigator.of(context).pushReplacementNamed(MaintenancePlanScreen.routeName),
                        ),
                        SizedBox(width: 24),
                        MenuOption(
                          title: "Phân tích sự cố",
                          subtitle: "Defect Analysis",
                          iconData: Ionicons.analytics,
                          selected: false,
                          action: () => {},
                        ),
                        SizedBox(width: 24),
                        MenuOption(
                          title: "Bảo trì hệ thống",
                          subtitle: "Maintenance Systems",
                          iconData: Ionicons.construct_outline,
                          selected: true,
                          action: () => {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return TopHeaderSub(
      title: "maintenance.title".tr(),
      subtitle: "maintenance.subtitle".tr(),
    );
  }
}

class MenuOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData iconData;
  final bool selected;
  final Function action;

  MenuOption({required this.title, this.subtitle, required this.iconData, required this.selected, required this.action});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          onTap: action as void Function(),
          child: Container(
              decoration: BoxDecoration(
                color: selected ? Color(0xFFFF5A5F) : Colors.grey[200],
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: selected ? Color(0xFFFF5A5F).withOpacity(0.2) : Colors.transparent,
                    spreadRadius: 4,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconData,
                    size: 50,
                    color: selected ? Colors.white : Colors.grey[500],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.grey[500],
                      fontSize: getProportionateScreenWidth(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  (subtitle != null)
                      ? Text(
                          subtitle!,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.grey[500],
                            fontSize: getProportionateScreenWidth(10),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              )),
        ),
      ),
    );
  }
}
