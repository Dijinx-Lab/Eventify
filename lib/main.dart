import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/firebase_options.dart';
import 'package:eventify/routes/custom_routes.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await PrefUtils().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    title: 'Event Bazaar',
    debugShowCheckedModeBanner: false,
    navigatorObservers: [FlutterSmartDialog.observer],
    builder: FlutterSmartDialog.init(),
    theme: ThemeData(
      useMaterial3: false,
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
