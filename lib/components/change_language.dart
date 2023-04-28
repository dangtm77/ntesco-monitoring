import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants.dart';

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Locale groupValue = context.locale;
    return CupertinoSlidingSegmentedControl<Locale>(
      groupValue: groupValue,
      children: {
        context.supportedLocales[0]: Text("EN", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w900, fontSize: 13)),
        context.supportedLocales[1]: Text("VI", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w900, fontSize: 13)),
      },
      onValueChanged: (value) async {
        await context.setLocale(value!);
      },
    );
  }
}
