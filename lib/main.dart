import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/routes/custom_routes.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtils().init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    title: 'Eventify',
    debugShowCheckedModeBanner: false,
    navigatorObservers: [FlutterSmartDialog.observer],
    builder: FlutterSmartDialog.init(),
    theme: ThemeData(
      primaryColor: ColorStyle.primaryColor,
      fontFamily: "Lato",
      canvasColor: ColorStyle.whiteColor,
      primarySwatch: ColorStyle.primaryMaterialColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: initialRouteWithNoArgs,
    onGenerateRoute: CustomRoutes.allRoutes,
  ));
}
