import 'dart:convert';
import 'package:eventify/models/api_models/category_response/category_response.dart';
import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';

class CategoryService {
  Future<BaseResponse> getCategories({bool isForAll = false}) async {
    try {
      var url = Uri.parse(isForAll
          ? ApiConstants.getAllCategories
          : ApiConstants.getPopularCategories);

      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        CategoryResponse apiResponse = CategoryResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }
}
