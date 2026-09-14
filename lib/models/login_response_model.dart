// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    bool status;
    String message;
    String token;
    User user;

    LoginResponseModel({
        required this.status,
        required this.message,
        required this.token,
        required this.user,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "user": user.toJson(),
    };
}

class User {
    int id;
    String name;

    User({
        required this.id,
        required this.name,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
