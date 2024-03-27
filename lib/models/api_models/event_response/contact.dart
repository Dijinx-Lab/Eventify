class Contact {
  final String? name;
  final String? phone;
  final String? email;
  final String? whatsapp;
  final String? organization;

  Contact({
    this.name,
    this.phone,
    this.email,
    this.whatsapp,
    this.organization,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        whatsapp: json["whatsapp"],
        organization: json["organization"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "email": email,
        "whatsapp": whatsapp,
        "organization": organization,
      };
}
