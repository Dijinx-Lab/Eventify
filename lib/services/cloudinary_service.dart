import 'dart:convert';
import 'package:eventify/models/api_models/base_response/base_response.dart';
import 'package:eventify/models/api_models/cloudinary_response/cloudinary_upload_response.dart';
import 'package:http/http.dart' as http;
import 'package:eventify/constants/api_keys.dart';

class CloudinaryService {
  Future<BaseResponse> uploadImages(String imagePath) async {
    try {
      var url = Uri.parse(ApiConstants.cloudinaryUpload);
      var request = http.MultipartRequest("POST", url);
      http.MultipartFile imageFile =
          await http.MultipartFile.fromPath('file', imagePath);
      request.files.add(imageFile);
      request.fields["timestamp"] = DateTime.timestamp().toIso8601String();
      request.fields["api_key"] = "334784716684813";
      request.fields["upload_preset"] = "ynkswnyt";
      var value = await request.send();

      if (value.statusCode == 200) {
        final response = await http.Response.fromStream(value);
        var responseBody = json.decode(response.body);

        CloudinaryUploadResponse apiResponse =
            CloudinaryUploadResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        final response = await http.Response.fromStream(value);

        return BaseResponse(null, response.body);
      }
    } catch (ex) {
      print(ex);
      return BaseResponse(null, ex.toString());
    }
  }
}
