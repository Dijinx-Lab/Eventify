import 'dart:collection';
import 'dart:convert';

import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';

class StatsService {
  Future<BaseResponse> updateStats(
      String? preference, bool? bookmarked, String id) async {
    try {
      var url = Uri.parse("${ApiConstants.updateStats}?id=$id");

      var params = HashMap();
      if (bookmarked != null) {
        params["bookmarked"] = bookmarked;
      }
      if (preference != null) {
        params["preference"] = preference;
      }

      http.Response response =
          await http.put(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });
      //print(url);
      //print(params);
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
