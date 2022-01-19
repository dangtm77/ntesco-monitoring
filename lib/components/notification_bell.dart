import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class NotificationBell extends StatefulWidget {
  NotificationBell({Key? key}) : super(key: key);

  @override
  _NotificationBellState createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  int totalUnreadNotification = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.notifications_none_rounded, color: kPrimaryColor, size: 40),
          if (totalUnreadNotification != 0)
            Positioned(
              top: -5,
              right: -10,
              child: Container(
                height: getProportionateScreenWidth(22),
                width: getProportionateScreenWidth(22),
                decoration: BoxDecoration(
                  color: Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 3, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$totalUnreadNotification",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(11),
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
