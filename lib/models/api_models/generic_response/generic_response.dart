class GenericResponse {
  bool? isSuccess;
  String? message;

  GenericResponse({this.isSuccess, this.message});

  GenericResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    return data;
  }
}
