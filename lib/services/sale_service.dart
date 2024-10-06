import 'dart:collection';
import 'dart:convert';

import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';
import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/api_models/sale_response/sale_list_response.dart';
import 'package:eventify/models/api_models/sale_response/sale_response.dart';
import 'package:eventify/models/screen_args/sale_args.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:http/http.dart' as http;

class SaleService {
  Future<BaseResponse> getSales(String filter) async {
    try {
      var url = Uri.parse("${ApiConstants.getSales}?filter=$filter");

      http.Response response = await http.get(url, headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        SaleListResponse apiResponse = SaleListResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> uploadSale(SaleArgs eventArgs) async {
    try {
      var url = Uri.parse(ApiConstants.addSale);
      var params = _getHashMap(eventArgs);

      http.Response response =
          await http.post(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        SaleResponse apiResponse = SaleResponse.fromJson(responseBody);

        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      //print(ex.toString());
      return BaseResponse(null, ex.toString());
    }
  }

  HashMap _getHashMap(SaleArgs eventArgs) {
    var params = HashMap();
    params["listing_visibile"] = eventArgs.listingVisible;
    params["name"] = eventArgs.name;
    params["description"] = eventArgs.description;
    params["start_date_time"] = eventArgs.startDateTime;
    params["end_date_time"] = eventArgs.endDateTime;
    params["link_to_stores"] = eventArgs.linkToStores;
    params["website"] = eventArgs.website;
    params["discount_description"] = eventArgs.discountDescription;
    params["images"] = eventArgs.images;
    params["contact"] = {
      "name": eventArgs.contactName,
      "phone": eventArgs.contactPhone,
      "email": eventArgs.contactEmail,
      "whatsapp": eventArgs.contactWhatsApp,
      "organization": eventArgs.contactOrganization
    };

    return params;
  }

  Future<BaseResponse> editSale(SaleArgs eventArgs) async {
    try {
      var url = Uri.parse('${ApiConstants.updateSale}?id=${eventArgs.eventId}');
      var params = _getHashMap(eventArgs);

      http.Response response =
          await http.put(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        SaleResponse apiResponse = SaleResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      //print(ex.toString());
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> toggleListing(String saleId, bool listingVisible) async {
    try {
      var url = Uri.parse('${ApiConstants.updateSale}?id=$saleId');
      var params = HashMap();
      params["listing_visibile"] = listingVisible;

      

      http.Response response =
          await http.put(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });
      

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        SaleResponse apiResponse = SaleResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      //print(ex.toString());
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> deleteSale(String saleId) async {
    try {
      var url = Uri.parse("${ApiConstants.deleteSale}?id=$saleId");

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
