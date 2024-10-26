import 'package:eventify/constants/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  factory PrefUtils() => PrefUtils._internal();

  PrefUtils._internal();

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  bool get getIsAppTypeCustomer => _sharedPreferences!.getBool(appType) ?? true;

  set setIsAppTypeCustomer(bool type) {
    _sharedPreferences!.setBool(appType, type);
  }

  bool get getIsUserLoggedIn =>
      _sharedPreferences!.getBool(userLoggedIn) ?? false;

  set setIsUserLoggedIn(bool type) {
    _sharedPreferences!.setBool(userLoggedIn, type);
  }

  bool get getIsUserOnboarded =>
      _sharedPreferences!.getBool(userOnboarded) ?? false;

  set setIsUserOnboarded(bool type) {
    _sharedPreferences!.setBool(userOnboarded, type);
  }

  String get getFirstName => _sharedPreferences!.getString(userFirstName) ?? '';

  set setFirstName(String value) {
    _sharedPreferences!.setString(userFirstName, value);
  }

  String get getLasttName => _sharedPreferences!.getString(userLastName) ?? '';

  set setLasttName(String value) {
    _sharedPreferences!.setString(userLastName, value);
  }

  int get getAge => _sharedPreferences!.getInt(userAge) ?? 0;

  set setAge(int value) {
    _sharedPreferences!.setInt(userAge, value);
  }

  String get getEmail => _sharedPreferences!.getString(userEmail) ?? '';

  set setEmail(String value) {
    _sharedPreferences!.setString(userEmail, value);
  }

  String get getCountryCode =>
      _sharedPreferences!.getString(userCountryCode) ?? '';

  set setCountryCode(String value) {
    _sharedPreferences!.setString(userCountryCode, value);
  }

  String get getPhone => _sharedPreferences!.getString(userPhone) ?? '';

  set setPhone(String value) {
    _sharedPreferences!.setString(userPhone, value);
  }

  String get getToken => _sharedPreferences!.getString(userToken) ?? '';

  set setToken(String value) {
    _sharedPreferences!.setString(userToken, value);
  }

  bool get getNotificationsEnabled =>
      _sharedPreferences!.getBool(notificationsEnabled) ?? true;

  set setNotificationsEnabled(bool type) {
    _sharedPreferences!.setBool(notificationsEnabled, type);
  }

  String get getSignInMethod =>
      _sharedPreferences!.getString(signInMethod) ?? "";

  set setSignInMethod(String type) {
    _sharedPreferences!.setString(signInMethod, type);
  }

  String get getCity => _sharedPreferences!.getString(userCity) ?? '';

  set setCity(String value) {
    _sharedPreferences!.setString(userCity, value);
  }

  String get getAppPreference => _sharedPreferences!.getString(appSide) ?? '';

  set setAppPreference(String value) {
    _sharedPreferences!.setString(appSide, value);
  }

  String get lastBrand => _sharedPreferences!.getString(lastBrandName) ?? '';

  set lastBrand(String value) {
    _sharedPreferences!.setString(lastBrandName, value);
  }
}
