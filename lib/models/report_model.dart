// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
    bool status;
    List<Report> events;

    ReportModel({
        required this.status,
        required this.events,
    });

    factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        status: json["status"],
        events: List<Report>.from(json["events"].map((x) => Report.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
    };
}

class Report {
    String event;
    int totalRegistered;
    int present;
    int absent;
    int notMarked;

    Report({
        required this.event,
        required this.totalRegistered,
        required this.present,
        required this.absent,
        required this.notMarked,
    });

    factory Report.fromJson(Map<String, dynamic> json) => Report(
        event: json["event"],
        totalRegistered: json["total_registered"],
        present: json["present"],
        absent: json["absent"],
        notMarked: json["not_marked"],
    );

    Map<String, dynamic> toJson() => {
        "event": event,
        "total_registered": totalRegistered,
        "present": present,
        "absent": absent,
        "not_marked": notMarked,
    };
}
