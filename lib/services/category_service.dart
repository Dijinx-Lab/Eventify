import 'dart:convert';
import 'package:eventify/models/api_models/category_response/category_list_response.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';

class CategoryService {
  Future<BaseResponse> getCategories() async {
    try {
      var url = Uri.parse(ApiConstants.getCategories);

      http.Response response = await http.get(url, headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        CategoryListResponse apiResponse =
            CategoryListResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }
}
