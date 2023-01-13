import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import '../size_config.dart';
import 'notification_bell.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [Icon(Ionicons.grid_outline, color: kPrimaryColor, size: 30)],
            ),
          ),
          Image.asset("assets/images/logofull.png", width: getProportionateScreenWidth(110)),
          NotificationBell()
        ],
      ),
    );
  }
}

class TopHeaderSub extends StatelessWidget {
  final String title;
  final String subtitle;
  final InkWell? buttonLeft;
  final InkWell? buttonRight;
  const TopHeaderSub({Key? key, required this.title, required this.subtitle, this.buttonLeft, this.buttonRight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(5), horizontal: getProportionateScreenWidth(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buttonLeft ??
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 35.0)],
                ),
              ),
          Column(
            children: [
              Text(title, style: TextStyle(fontSize: 20, color: kPrimaryColor, fontWeight: FontWeight.w700)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: kSecondaryColor)),
            ],
          ),
          buttonRight ??
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [Icon(Ionicons.information_circle_outline, color: kPrimaryColor, size: 35.0)],
                ),
              )
        ],
      ),
    );
  }
}
