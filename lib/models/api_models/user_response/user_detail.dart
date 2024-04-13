class UserDetail {
  final String? firstName;
  final String? lastName;
  final String? age;
  final String? email;
  final String? countryCode;
  final String? phone;
  final String? authToken;
  final bool? notificationsEnabled;
  final DateTime? lastSigninOn;
  final String? loginMethod;
  final String? appSidePreference;

  UserDetail(
      {this.firstName,
      this.lastName,
      this.age,
      this.email,
      this.countryCode,
      this.phone,
      this.authToken,
      this.lastSigninOn,
      this.notificationsEnabled,
      this.loginMethod,
      this.appSidePreference});

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
      firstName: json["first_name"],
      lastName: json["last_name"],
      age: json["age"].toString(),
      email: json["email"],
      countryCode: json["country_code"],
      phone: json["phone"],
      authToken: json["auth_token"],
      lastSigninOn: json["last_signin_on"] == null
          ? null
          : DateTime.parse(json["last_signin_on"]),
      notificationsEnabled: json["notifications_enabled"],
      loginMethod: json["login_method"],
      appSidePreference: json["app_side_preference"]);

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "age": age,
        "email": email,
        "country_code": countryCode,
        "phone": phone,
        "auth_token": authToken,
        "last_signin_on": lastSigninOn?.toIso8601String(),
        "notifications_enabled": notificationsEnabled,
        "login_method": loginMethod,
        "app_side_preference": appSidePreference
      };
}
