// To parse this JSON data, do
//
//     final scanModel = scanModelFromJson(jsonString);

import 'dart:convert';

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
    bool status;
    Devotee devotee;
    // Nullable: a devotee who hasn't been marked present yet has no
    // attendance record, and the API sends `null` in that case.
    Attendance? attendance;

    ScanModel({
        required this.status,
        required this.devotee,
        this.attendance,
    });

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        status: json["status"],
        devotee: Devotee.fromJson(json["devotee"]),
        attendance: json["attendance"] == null ? null : Attendance.fromJson(json["attendance"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "devotee": devotee.toJson(),
        "attendance": attendance?.toJson(),
    };
}

class Attendance {
    String status;
    String? markedBy;
    DateTime? markedAt;

    Attendance({
        required this.status,
        this.markedBy,
        this.markedAt,
    });

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        status: json["status"],
        markedBy: json["marked_by"],
        markedAt: json["marked_at"] == null ? null : DateTime.parse(json["marked_at"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "marked_by": markedBy,
        "marked_at": markedAt?.toIso8601String(),
    };
}

class Devotee {
    int id;
    String uniqueNumber;
    String name;
    String mobile;
    String gender;
    int age;
    String photo;
    String attendingFor;
    String timeSlot;
    String slotLocation;

    Devotee({
        required this.id,
        required this.uniqueNumber,
        required this.name,
        required this.mobile,
        required this.gender,
        required this.age,
        required this.photo,
        required this.attendingFor,
        required this.timeSlot,
        required this.slotLocation,
    });

    factory Devotee.fromJson(Map<String, dynamic> json) => Devotee(
        id: json["id"],
        uniqueNumber: json["unique_number"],
        name: json["name"],
        mobile: json["mobile"],
        gender: json["gender"],
        age: json["age"],
        photo: json["photo"],
        attendingFor: json["attending_for"],
        timeSlot: json["time_slot"],
        slotLocation: json["slot_location"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "unique_number": uniqueNumber,
        "name": name,
        "mobile": mobile,
        "gender": gender,
        "age": age,
        "photo": photo,
        "attending_for": attendingFor,
        "time_slot": timeSlot,
        "slot_location": slotLocation,
    };
}
