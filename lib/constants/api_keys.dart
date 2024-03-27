class ApiConstants {
  static const String baseUrl = "http://localhost:3000/api/v1/eventify";

  static const String signIn = "$baseUrl/user/sign-in";
  static const String signUp = "$baseUrl/user/sign-up";
  static const String verify = "$baseUrl/user/verify";
  static const String sendOtp = "$baseUrl/user/verify/send";

  static const String getCategories = "$baseUrl/category/list";

  static const String getEvents = "$baseUrl/event/list";

  static const String updateStats = "$baseUrl/stats/update";

  static const String getPopularCategories =
      "$baseUrl/api/Category/GetPopularCategories";
  static const String getAllCategories = "$baseUrl/api/Category/GetAll";

  static const String cloudinaryUpload =
      "https://api.cloudinary.com/v1_1/djhgeh6nt/image/upload";

  static const String uploadEvent = "$baseUrl/api/Event/AddEvent";
  static const String updateEvent = "$baseUrl/api/Event/UpdateEvent";
}
