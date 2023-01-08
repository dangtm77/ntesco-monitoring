import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import '../size_config.dart';
import 'notification_bell.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.sort_rounded, color: kPrimaryColor, size: 45)
              ],
            ),
          ),
          Image.asset("assets/images/logofull.png",
              width: getProportionateScreenWidth(110)),
          NotificationBell()
        ],
      ),
    );
  }
}

class TopHeaderSub extends StatelessWidget {
  final String title;
  final String subtitle;
  final InkWell button;
  const TopHeaderSub({Key? key, required this.title, required this.subtitle, required this.button})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: kPrimaryColor,
                  size: 30,
                )
              ],
            ),
          ),
          Column(
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700)),
              Text(subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: kSecondaryColor,
                  )),
            ],
          ),
          button
          // InkWell(
          //   borderRadius: BorderRadius.circular(15),
          //   onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
          //   child: Stack(
          //     clipBehavior: Clip.none,
          //     children: [
          //       Icon(Icons.error_outline_rounded, color: kPrimaryColor, size: 40)
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
