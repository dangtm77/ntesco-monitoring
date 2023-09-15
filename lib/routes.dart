import 'package:flutter/widgets.dart';
import 'package:ntesco_smart_monitoring/screens/contact_us/contact_us_screen.dart';
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/update.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/update/details/update.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/defect_analysis_screen.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/plan_screen.dart';
import 'package:ntesco_smart_monitoring/screens/signin/signin_screen.dart';
import 'package:ntesco_smart_monitoring/screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ContactUsScreen.routeName: (context) => ContactUsScreen(),
  // ListOfDeXuatScreen.routeName: (context) => ListOfDeXuatScreen(),
  // DetailOfDeXuatScreen.routeName: (context) => DetailOfDeXuatScreen(),
  // CreateDeXuatScreen.routeName: (context) => CreateDeXuatScreen(),
  // MaintenanceScreen.routeName: (context) => MaintenanceScreen(),
  //PlanScreen.routeName: (context) => PlanScreen(),
  DefectAnalysisScreen.routeName: (context) => DefectAnalysisScreen(),
  DefectAnalysisUpdateScreen.routeName: (context) => DefectAnalysisUpdateScreen(),
  DefectAnalysisDetailsUpdateScreen.routeName: (context) => DefectAnalysisDetailsUpdateScreen(),
  // MaintenanceUpdateScreen.routeName: (context) => MaintenanceUpdateScreen(),
};
