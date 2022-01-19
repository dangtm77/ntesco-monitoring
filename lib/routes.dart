import 'package:flutter/widgets.dart';
import 'package:ntesco_smart_monitoring/screens/contact_us/contact_us_screen.dart'; 
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import 'package:ntesco_smart_monitoring/screens/reports/report_screen.dart'; 
import 'package:ntesco_smart_monitoring/screens/signin/signin_screen.dart';
import 'package:ntesco_smart_monitoring/screens/splash/splash_screen.dart'; 

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(), 
  HomeScreen.routeName: (context) => HomeScreen(),  
  
  ContactUsScreen.routeName: (context) => ContactUsScreen(), 
  ReportsScreen.routeName: (context) => ReportsScreen(),
};
