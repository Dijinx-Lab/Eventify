import 'dart:collection';
import 'dart:convert';

import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/api_models/pass_response/pass.dart';
import 'package:eventify/models/api_models/pass_response/pass_response.dart';
import 'package:eventify/utils/pref_utils.dart';

import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';

class PassService {
  Future<BaseResponse> addPasses(List<Pass> passes) async {
    try {
      var url = Uri.parse(ApiConstants.addPasses);
      var passesJson = passes.map((pass) => pass.toJson()).toList();
      var params = HashMap();

      params["passes"] = passesJson;

      http.Response response =
          await http.post(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        PassResponse apiResponse = PassResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      //print(ex.toString());
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> deletePasses(String eventId) async {
    try {
      var url = Uri.parse("${ApiConstants.deletePasses}?id=$eventId");

      http.Response response = await http.delete(url, headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      //print(response.body);

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
