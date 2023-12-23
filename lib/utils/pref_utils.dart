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

  String get getUserEmail => _sharedPreferences!.getString(userEmail) ?? "";

  set setUserEmail(String value) {
    _sharedPreferences!.setString(userEmail, value);
  }

  String get getUserFirstName =>
      _sharedPreferences!.getString(userFirstName) ?? "";

  set setUserFirstName(String value) {
    _sharedPreferences!.setString(userFirstName, value);
  }

  String get getUserLastName =>
      _sharedPreferences!.getString(userLastName) ?? "";

  set setUserLastName(String value) {
    _sharedPreferences!.setString(userLastName, value);
  }

  String get getUserPhone => _sharedPreferences!.getString(userPhone) ?? "";

  set setUserPhone(String value) {
    _sharedPreferences!.setString(userPhone, value);
  }

  String get getUserAge => _sharedPreferences!.getString(userAge) ?? "";

  set setUserAge(String value) {
    _sharedPreferences!.setString(userAge, value);
  }

  String get getUserToken => _sharedPreferences!.getString(userToken) ?? "";

  set setUserToken(String value) {
    _sharedPreferences!.setString(userToken, value);
  }
}
