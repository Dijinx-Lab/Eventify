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
}
