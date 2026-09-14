// To parse this JSON data, do
//
//     final markModel = markModelFromJson(jsonString);

import 'dart:convert';

MarkModel markModelFromJson(String str) => MarkModel.fromJson(json.decode(str));

String markModelToJson(MarkModel data) => json.encode(data.toJson());

class MarkModel {
    bool status;
    String message;
    Data data;

    MarkModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory MarkModel.fromJson(Map<String, dynamic> json) => MarkModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int devoteeId;
    String uniqueNumber;
    String name;
    String event;
    String status;
    String markedBy;
    DateTime markedAt;

    Data({
        required this.devoteeId,
        required this.uniqueNumber,
        required this.name,
        required this.event,
        required this.status,
        required this.markedBy,
        required this.markedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        devoteeId: json["devotee_id"],
        uniqueNumber: json["unique_number"],
        name: json["name"],
        event: json["event"],
        status: json["status"],
        markedBy: json["marked_by"],
        markedAt: DateTime.parse(json["marked_at"]),
    );

    Map<String, dynamic> toJson() => {
        "devotee_id": devoteeId,
        "unique_number": uniqueNumber,
        "name": name,
        "event": event,
        "status": status,
        "marked_by": markedBy,
        "marked_at": markedAt.toIso8601String(),
    };
}
