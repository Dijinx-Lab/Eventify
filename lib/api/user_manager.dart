import 'dart:collection';
import 'dart:convert';
import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';

class UserManager {
  Future<BaseResponse> signIn(String emailOrPhone, String password) async {
    try {
      var url = Uri.parse(ApiConstants.signIn);

      var params = HashMap();
      params["emailOrPhone"] = emailOrPhone;
      params["userPassword"] = password;

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

  Future<BaseResponse> signUp(
      String userFirstName,
      String userLastName,
      String userEmail,
      String userPassword,
      String userConfirmPassword,
      int age,
      String userPhoneNumber,
      bool isVendor) async {
    try {
      var url = Uri.parse(ApiConstants.signUp);

      var params = HashMap();
      params["userFirstName"] = userFirstName;
      params["userLastName"] = userLastName;
      params["userEmail"] = userEmail;
      params["userPassword"] = userPassword;
      params["userConfirmPassword"] = userConfirmPassword;
      params["age"] = age;
      params["userPhoneNumber"] = userPhoneNumber;
      params["isVendor"] = isVendor;

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
}
