class UserContact {
  final String? firstName;
  final dynamic lastName;
  final String? email;
  final dynamic countryCode;
  final dynamic phone;

  UserContact({
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.phone,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) => UserContact(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        countryCode: json["country_code"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "country_code": countryCode,
        "phone": phone,
      };
}
