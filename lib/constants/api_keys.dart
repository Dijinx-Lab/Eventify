class ApiConstants {
  static const String baseUrl = "http://192.168.100.228:3000/api/v1/eventify";
  // "https://eventify-server-sand.vercel.app/api/v1/eventify";

  static const String signIn = "$baseUrl/user/sign-in";
  static const String signOut = "$baseUrl/user/sign-out";
  static const String signUp = "$baseUrl/user/sign-up";
  static const String sso = "$baseUrl/user/sso";
  static const String userDetails = "$baseUrl/user/detail";
  static const String verify = "$baseUrl/user/verify";
  static const String sendOtp = "$baseUrl/user/verify/send";
  static const String updateProfile = "$baseUrl/user/edit-profile";
  static const String changePassword = "$baseUrl/user/change-password";
  static const String forgotPassword = "$baseUrl/user/forgot-password";
  static const String getDoc = "$baseUrl/utility/docs";

  static const String getCategories = "$baseUrl/category/list";

  static const String getEvents = "$baseUrl/event/list";

  static const String updateStats = "$baseUrl/stats/update";
  static const String getStatsUsers = "$baseUrl/stats/users";

  static const String addPasses = "$baseUrl/pass/create/all";
  static const String deletePasses = "$baseUrl/pass/delete/all";

  static const String addEvent = "$baseUrl/event/create";
  static const String updateEvent = "$baseUrl/event/update";
  static const String deleteEvent = "$baseUrl/event/delete";

  static const String cloudinaryUpload =
      "https://api.cloudinary.com/v1_1/djhgeh6nt/image/upload";

  static const String getSales = "$baseUrl/sale/list";
  static const String addSale = "$baseUrl/sale/create";
  static const String updateSale = "$baseUrl/sale/update";
  static const String deleteSale = "$baseUrl/sale/delete";
}
