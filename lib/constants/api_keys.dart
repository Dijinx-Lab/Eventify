class ApiConstants {
  static const String baseUrl = "https://eventifywebapis.azurewebsites.net";

  static const String signIn = "$baseUrl/api/Authentication/LoginUser";
  static const String signUp = "$baseUrl/api/Authentication/RegisterUser";

  static const String getEventsByCity =
      "$baseUrl/api/Event/GetAllEventsByCity?City=";
  static const String getEventsByUser =
      "$baseUrl/api/Event/GetAllEventsByUser?UserEmail=";

  static const String getPopularCategories =
      "$baseUrl/api/Category/GetPopularCategories";
  static const String getAllCategories = "$baseUrl/api/Category/GetAll";

  static const String cloudinaryUpload =
      "https://api.cloudinary.com/v1_1/djhgeh6nt/image/upload";

  static const String uploadEvent = "$baseUrl/api/Event/AddEvent";
  static const String updateEvent = "$baseUrl/api/Event/UpdateEvent";
}
