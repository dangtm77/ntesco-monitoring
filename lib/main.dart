import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ntesco_smart_monitoring/language/codegen_loader.g.dart';
import 'package:ntesco_smart_monitoring/routes.dart';
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import 'package:ntesco_smart_monitoring/screens/signin/signin_screen.dart';
import 'package:ntesco_smart_monitoring/screens/splash/splash_screen.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPreferences pre = await SharedPreferences.getInstance();
  var status = pre.getBool('ViewFirstTime');
  var isLoggedIn = pre.getBool('ISLOGGEDIN');
  Intl.defaultLocale = 'vi_VN';
  runApp(EasyLocalization(
    child: MyApp(status, isLoggedIn),
    supportedLocales: [
      Locale('en', 'US'),
      Locale('vi', 'VN'),
    ],
    path: 'assets/language',
    startLocale: Locale('vi', 'VN'),
    fallbackLocale: Locale('vi', 'VN'),
    saveLocale: true,
    assetLoader: CodegenLoader(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp(this.status, this.isLoggedIn);
  final bool? status;
  final bool? isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'NTesco App' + status.toString(),
      theme: theme(),
      initialRoute: (status == false || status == null) ? SplashScreen.routeName : ((isLoggedIn == false || isLoggedIn == null) ? SignInScreen.routeName : HomeScreen.routeName),
      routes: routes,
    );
  }
}
