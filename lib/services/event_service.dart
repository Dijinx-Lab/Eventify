import 'dart:collection';
import 'dart:convert';

import 'package:eventify/models/api_models/event_response/event_list_response.dart';
import 'package:eventify/models/api_models/event_response/event_response.dart';
import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/screen_args/event_args.dart';
import 'package:eventify/utils/pref_utils.dart';

import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';
import 'package:eventify/models/api_models/base_response/base_response.dart';

class EventService {
  Future<BaseResponse> getEvents(String filter) async {
    try {
      var url = Uri.parse("${ApiConstants.getEvents}?filter=$filter");

      http.Response response = await http.get(url, headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
      });

      //print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        EventListResponse apiResponse =
            EventListResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> uploadEvent(
      EventArgs eventArgs, List<String> passIds) async {
    try {
      var url = Uri.parse(ApiConstants.addEvent);
      var params = _getHashMap(eventArgs, passIds);

      http.Response response =
          await http.post(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });
      print(params);
      print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        EventResponse apiResponse = EventResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      print(ex.toString());
      return BaseResponse(null, ex.toString());
    }
  }

  HashMap _getHashMap(EventArgs eventArgs, List<String> passIds) {
    var params = HashMap();
    params["listing_visibile"] = eventArgs.listingVisible;
    params["name"] = eventArgs.name;
    params["description"] = eventArgs.description;
    params["category_id"] = eventArgs.categoryId;
    params["date_time"] = eventArgs.dateTime;
    params["address"] = eventArgs.address;
    params["city"] = eventArgs.city;
    params["latitude"] = eventArgs.latitude;
    params["longitude"] = eventArgs.longitude;
    params["max_capacity"] = eventArgs.maxCapacity;
    params["price_type"] = eventArgs.priceType;
    params["price_starts_from"] = eventArgs.priceStartsFrom;
    params["price_goes_upto"] = eventArgs.priceGoesUpto;
    params["images"] = eventArgs.images;
    params["pass_ids"] = passIds;
    params["contact"] = {
      "name": eventArgs.contactName,
      "phone": eventArgs.contactPhone,
      "email": eventArgs.contactEmail,
      "whatsapp": eventArgs.contactWhatsApp,
      "organization": eventArgs.contactOrganization
    };

    return params;
  }

  Future<BaseResponse> editEvent(
      EventArgs eventArgs, List<String> passIds) async {
    try {
      var url =
          Uri.parse('${ApiConstants.updateEvent}?id=${eventArgs.eventId}');
      var params = _getHashMap(eventArgs, passIds);

      http.Response response =
          await http.put(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      print(params);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        EventResponse apiResponse = EventResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      print(ex.toString());
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> toggleListing(
      String eventId, bool listingVisible) async {
    try {
      var url = Uri.parse('${ApiConstants.updateEvent}?id=$eventId');
      var params = HashMap();
      params["listing_visibile"] = listingVisible;

      http.Response response =
          await http.put(url, body: json.encode(params), headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        EventResponse apiResponse = EventResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      print(ex.toString());
      return BaseResponse(null, ex.toString());
    }
  }

  Future<BaseResponse> deleteEvent(String eventId) async {
    try {
      var url = Uri.parse("${ApiConstants.deleteEvent}?id=$eventId");

      http.Response response = await http.delete(url, headers: {
        "Authorization": "Bearer ${PrefUtils().getToken}",
        "content-type": "application/json"
      });

      print(response.body);

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
