import 'dart:collection';
import 'dart:convert';

import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';

class UserService {
  Future<BaseResponse> signIn(String email, String password) async {
    try {
      var url = Uri.parse(ApiConstants.signIn);

      var params = HashMap();
      params["email"] = email;
      params["password"] = password;

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

      print(params);

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
      print(response.body);
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
}
