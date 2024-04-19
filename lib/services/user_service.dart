import 'dart:collection';
import 'dart:convert';

import 'package:eventify/models/api_models/doc_response/doc_response.dart';
import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';

class UserService {
  Future<BaseResponse> signIn(
      String email, String password, String? fcmToken) async {
    try {
      var url = Uri.parse(ApiConstants.signIn);

      var params = HashMap();
      params["email"] = email;
      params["password"] = password;
      if (fcmToken != null) params["fcm_token"] = fcmToken;

      http.Response response = await http.post(url,
          body: json.encode(params),
          headers: {"content-type": "application/json"});

      if (response.statusCode == 403) {
        return BaseResponse(null, response.statusCode.toString());
      } else if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> signOut() async {
    try {
      var url = Uri.parse(ApiConstants.signOut);

      http.Response response = await http.delete(url, headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse apiResponse = GenericResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> signInWithPhone(String countryCode, String phone,
      String password, String? fcmToken) async {
    try {
      var url = Uri.parse(ApiConstants.signIn);

      var params = HashMap();
      params["country_code"] = countryCode;
      params["phone"] = phone;
      params["password"] = password;
      if (fcmToken != null) params["fcm_token"] = fcmToken;

      //print(params);

      http.Response response = await http.post(url,
          body: json.encode(params),
          headers: {"content-type": "application/json"});

      if (response.statusCode == 403) {
        return BaseResponse(null, response.statusCode.toString());
      } else if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> sso(String? email, String? name, String? googleId,
      String? appleId, String? fcmToken) async {
    try {
      var url = Uri.parse(ApiConstants.sso);

      var params = HashMap();
      if (email != null) params["email"] = email;
      if (name != null) params["name"] = name;
      if (fcmToken != null) params["fcm_token"] = fcmToken;
      if (googleId != null) params["google_id"] = googleId;
      if (appleId != null) params["apple_id"] = appleId;

      http.Response response = await http.post(url,
          body: json.encode(params),
          headers: {"content-type": "application/json"});

      if (response.statusCode == 403) {
        return BaseResponse(null, response.statusCode.toString());
      } else if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> signUp(
      String firstName,
      String lastName,
      String email,
      String password,
      String confirmPassword,
      int age,
      String countryCode,
      String phone,
      String? fcmToken) async {
    try {
      var url = Uri.parse(ApiConstants.signUp);

      var params = HashMap();
      params["first_name"] = firstName;
      params["last_name"] = lastName;
      params["email"] = email;
      params["age"] = age;
      params["country_code"] = countryCode;
      params["phone"] = phone;
      params["password"] = password;
      params["confirm_password"] = confirmPassword;
      params["fcm_token"] = fcmToken;

      //print(params);

      http.Response response = await http.post(url,
          body: json.encode(params),
          headers: {"content-type": "application/json"});

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> getDetails() async {
    try {
      var url = Uri.parse(ApiConstants.userDetails);

      http.Response response = await http.get(url, headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      print(response.body);

      if (response.statusCode == 401) {
        return BaseResponse(null, response.statusCode.toString());
      } else if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> verifyOtp(String type, String code, String email) async {
    try {
      var url = Uri.parse(ApiConstants.verify);

      var params = HashMap();
      params["type"] = type;
      params["code"] = code;
      params["email"] = email;

      http.Response response = await http.post(url,
          body: json.encode(params),
          headers: {"content-type": "application/json"});
      //print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        dynamic apiResponse;
        if (type == "email") {
          apiResponse = UserResponse.fromJson(responseBody);
        } else {
          apiResponse = GenericResponse.fromJson(responseBody);
        }

        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> sendOtp(String type, String email) async {
    try {
      var url = Uri.parse(ApiConstants.sendOtp);

      var params = HashMap();
      params["type"] = type;
      params["email"] = email;

      http.Response response = await http.post(url,
          body: json.encode(params),
          headers: {"content-type": "application/json"});

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse apiResponse = GenericResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> updateProfile(
    String? firstName,
    String? lastName,
    String? phone,
    String? countryCode,
    String? lastCity,
    String? fcmToken,
    String? appSidePreference,
    String? age,
  ) async {
    try {
      var url = Uri.parse(ApiConstants.updateProfile);

      var params = HashMap();
      if (firstName != null) params["first_name"] = firstName;
      if (lastName != null) params["last_name"] = lastName;
      if (phone != null) params["country_code"] = countryCode;
      if (countryCode != null) params["phone"] = phone;
      if (lastCity != null) params["last_city"] = lastCity;
      if (fcmToken != null) params["fcm_token"] = fcmToken;
      if (age != null) params["age"] = int.tryParse(age);
      if (appSidePreference != null) {
        params["app_side_preference"] = appSidePreference;
      }

      //print(params);

      http.Response response =
          await http.put(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      //print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> changePassword(
    String oldPassword,
    String password,
    String confirmPassword,
  ) async {
    try {
      var url = Uri.parse(ApiConstants.changePassword);

      var params = HashMap();

      params["old_password"] = oldPassword;
      params["password"] = password;
      params["confirm_password"] = confirmPassword;

      http.Response response =
          await http.post(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> forgotPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      var url = Uri.parse(ApiConstants.forgotPassword);

      var params = HashMap();

      params["email"] = email;
      params["password"] = password;
      params["confirm_password"] = confirmPassword;

      http.Response response = await http.post(url,
          body: json.encode(params),
          headers: {"content-type": "application/json"});

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse apiResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> getDoc(bool isForTerms) async {
    try {
      var url = isForTerms
          ? Uri.parse("${ApiConstants.getDoc}?type=terms")
          : Uri.parse("${ApiConstants.getDoc}?type=privacy");

      http.Response response =
          await http.get(url, headers: {"content-type": "application/json"});

      //print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        DocResponse apiResponse = DocResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }
}
