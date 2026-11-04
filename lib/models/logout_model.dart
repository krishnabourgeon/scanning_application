
import 'dart:convert';

LogoutModel logoutModelFromJson(String str) =>
    LogoutModel.fromJson(json.decode(str));

String logoutModelToJson(LogoutModel data) =>
    json.encode(data.toJson());

class LogoutModel {
  final bool status;
  final String message;

  const LogoutModel({
    required this.status,
    required this.message,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      status: json['status'] == true,
      message: json['message']?.toString() ??
          'Something went wrong',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };
}
