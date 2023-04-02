import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/helper/network.dart';
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
    child: MyApp(status: status, isLoggedIn: isLoggedIn),
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

// class MyApp extends StatelessWidget {
//   final bool? status;
//   final bool? isLoggedIn;
//   const MyApp(this.status, this.isLoggedIn);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       supportedLocales: context.supportedLocales,
//       localizationsDelegates: context.localizationDelegates,
//       locale: context.locale,
//       debugShowCheckedModeBanner: false,
//       title: 'NTesco App' + status.toString(),
//       theme: theme(),
//       initialRoute: (status == false || status == null) ? SplashScreen.routeName : ((isLoggedIn == false || isLoggedIn == null) ? SignInScreen.routeName : HomeScreen.routeName),
//       routes: routes,
//     );
//   }
// }

class MyApp extends StatefulWidget {
  final bool? status;
  final bool? isLoggedIn;

  //MyApp(this.status, this.isLoggedIn);
  MyApp({Key? key, this.status, this.isLoggedIn}) : super(key: key);

  @override
  _MyAppState createState() => new _MyAppState(status, isLoggedIn);
}

class _MyAppState extends State<MyApp> {
  final bool? status;
  final bool? isLoggedIn;

  _MyAppState(this.status, this.isLoggedIn);

  late NetworkHelper _networkConnectivity = NetworkHelper.instance;
  bool isOnline = false;

  void initState() {
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      setState(() {
        switch (source.keys.toList()[0]) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
            isOnline = true;
            break;
          default:
            isOnline = false;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _networkConnectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var initRoute = HomeScreen.routeName;
    if (status == false || status == null) initRoute = SplashScreen.routeName;
    if (isLoggedIn == false || isLoggedIn == null) initRoute = SignInScreen.routeName;

    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'NTesco App',
      theme: theme(),
      initialRoute: initRoute,
      routes: routes,
    );
  }
}
