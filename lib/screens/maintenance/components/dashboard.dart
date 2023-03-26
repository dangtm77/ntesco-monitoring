import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/plan_screen.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Items> myList = <Items>[];
    myList.add(new Items(
      title: "Kế hoạch bảo trì",
      subtitle: "Maintenance plan",
      icon: Ionicons.calendar_outline,
      action: () => Navigator.pushNamed(context, MaintenancePlanScreen.routeName),
    ));
    myList.add(new Items(
      title: "Phân tích sự cố",
      subtitle: "Defect Analysis",
      icon: Ionicons.analytics,
      action: () => {},
    ));
    myList.add(new Items(
      title: "Bảo trì hệ thống",
      subtitle: "Maintenance Systems",
      icon: Ionicons.construct_outline,
      action: () => {},
    ));

    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 5, right: 5),
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: myList.map((data) {
            return InkWell(
              onTap: data.action as void Function(),
              child: Container(
                decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(data.icon, size: getProportionateScreenWidth(60), color: Colors.white),
                    SizedBox(height: 15),
                    Text(
                      data.title,
                      style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(14), fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    Text(
                      data.subtitle,
                      style: TextStyle(color: Colors.white70, fontSize: getProportionateScreenWidth(13), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  IoniconsData icon;
  Function action;
  Items({required this.title, required this.subtitle, required this.icon, required this.action});
}
