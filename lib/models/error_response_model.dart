class ErrorResponseModel {
  bool? status;
  String? errorMessage;
  ErrorResponseModel({this.errorMessage, this.status});
  ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorMessage = json['message'];
  }
}
