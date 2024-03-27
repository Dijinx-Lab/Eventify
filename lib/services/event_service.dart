import 'dart:collection';
import 'dart:convert';

import 'package:eventify/models/api_models/event_response/event_list_response.dart';
import 'package:eventify/models/api_models/generic_response/generic_response.dart';
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

//   Future<BaseResponse> getEventsByUser() async {
//     try {
//       String userCred = PrefUtils().getUserEmail != ""
//           ? PrefUtils().getUserEmail
//           : PrefUtils().getUserPhone;
//       var url = Uri.parse(ApiConstants.getEventsByUser + userCred);

//       http.Response response = await http.get(url);

//       if (response.statusCode == 200) {
//         var responseBody = json.decode(response.body);
//         EventListResponse apiResponse =
//             EventListResponse.fromJson(responseBody);
//         return BaseResponse(apiResponse, null);
//       } else {
//         return BaseResponse(null, response.body);
//       }
//     } catch (ex) {
//       return BaseResponse(null, ex.toString());
//     }
//   }

//   Future<BaseResponse> uploadEvent(Event event) async {
//     try {
//       var url = Uri.parse(ApiConstants.uploadEvent);

//       http.Response response = await http.post(url,
//           body: json.encode(event.toJson()),
//           headers: {"content-type": "application/json"});

//       if (response.statusCode == 200) {
//         var responseBody = json.decode(response.body);

//         GenericResponse apiResponse = GenericResponse.fromJson(responseBody);
//         return BaseResponse(apiResponse, null);
//       } else {
//         return BaseResponse(null, response.body);
//       }
//     } catch (ex) {
//       return BaseResponse(null, ex.toString());
//     }
//   }

//   Future<BaseResponse> editEvent(Event event) async {
//     try {
//       var url = Uri.parse(ApiConstants.updateEvent);

//       http.Response response = await http.put(url,
//           body: json.encode(event.toJson()),
//           headers: {"content-type": "application/json"});

//       if (response.statusCode == 200) {
//         var responseBody = json.decode(response.body);

//         GenericResponse apiResponse = GenericResponse.fromJson(responseBody);
//         return BaseResponse(apiResponse, null);
//       } else {
//         return BaseResponse(null, response.body);
//       }
//     } catch (ex) {
//       return BaseResponse(null, ex.toString());
//     }
//   }
}
