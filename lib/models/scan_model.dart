// // To parse this JSON data, do
// //
// //     final scanModel = scanModelFromJson(jsonString);

// import 'dart:convert';

// ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

// String scanModelToJson(ScanModel data) => json.encode(data.toJson());

// class ScanModel {
//     bool status;
//     Devotee devotee;
//     // Nullable: a devotee who hasn't been marked present yet has no
//     // attendance record, and the API sends `null` in that case.
//     Attendance? attendance;

//     ScanModel({
//         required this.status,
//         required this.devotee,
//         this.attendance,
//     });

//     factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
//         status: json["status"],
//         devotee: Devotee.fromJson(json["devotee"]),
//         attendance: json["attendance"] == null ? null : Attendance.fromJson(json["attendance"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "devotee": devotee.toJson(),
//         "attendance": attendance?.toJson(),
//     };
// }

// class Attendance {
//     String status;
//     String? markedBy;
//     DateTime? markedAt;

//     Attendance({
//         required this.status,
//         this.markedBy,
//         this.markedAt,
//     });

//     factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
//         status: json["status"],
//         markedBy: json["marked_by"],
//         markedAt: json["marked_at"] == null ? null : DateTime.parse(json["marked_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "marked_by": markedBy,
//         "marked_at": markedAt?.toIso8601String(),
//     };
// }

// class Devotee {
//     int id;
//     String uniqueNumber;
//     String name;
//     String mobile;
//     String gender;
//     int age;
//     String photo;
//     String attendingFor;
//     // Nullable: not every devotee has a slot assigned, and the API sends
//     // `null` in that case.
//     String? timeSlot;
//     String? slotLocation;

//     Devotee({
//         required this.id,
//         required this.uniqueNumber,
//         required this.name,
//         required this.mobile,
//         required this.gender,
//         required this.age,
//         required this.photo,
//         required this.attendingFor,
//         this.timeSlot,
//         this.slotLocation,
//     });

//     factory Devotee.fromJson(Map<String, dynamic> json) => Devotee(
//         id: json["id"],
//         uniqueNumber: json["unique_number"],
//         name: json["name"],
//         mobile: json["mobile"],
//         gender: json["gender"],
//         age: json["age"],
//         photo: json["photo"],
//         attendingFor: json["attending_for"],
//         timeSlot: json["time_slot"],
//         slotLocation: json["slot_location"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "unique_number": uniqueNumber,
//         "name": name,
//         "mobile": mobile,
//         "gender": gender,
//         "age": age,
//         "photo": photo,
//         "attending_for": attendingFor,
//         "time_slot": timeSlot,
//         "slot_location": slotLocation,
//     };
// }







// To parse this JSON data, do
//
//     final scanModel = scanModelFromJson(jsonString);

import 'dart:convert';

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
    bool status;
    String event;
    bool alreadyMarked;
    bool counted;
    int scanCount;
    String message;
    Devotee devotee;
    // Nullable: a devotee who hasn't been marked present yet has no
    // attendance record, and the API sends `null` in that case.
    Attendance? attendance;
    List<RecentScan> recentScans;

    ScanModel({
        required this.status,
        required this.event,
        required this.alreadyMarked,
        required this.counted,
        required this.scanCount,
        required this.message,
        required this.devotee,
        this.attendance,
        required this.recentScans,
    });

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        status: json["status"],
        event: json["event"],
        alreadyMarked: json["already_marked"],
        counted: json["counted"],
        scanCount: json["scan_count"],
        message: json["message"],
        devotee: Devotee.fromJson(json["devotee"]),
        attendance: json["attendance"] == null ? null : Attendance.fromJson(json["attendance"]),
        recentScans: json["recent_scans"] == null
            ? []
            : List<RecentScan>.from(json["recent_scans"].map((x) => RecentScan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "event": event,
        "already_marked": alreadyMarked,
        "counted": counted,
        "scan_count": scanCount,
        "message": message,
        "devotee": devotee.toJson(),
        "attendance": attendance?.toJson(),
        "recent_scans": List<dynamic>.from(recentScans.map((x) => x.toJson())),
    };
}

class Attendance {
    String status;
    String? markedBy;
    DateTime? markedAt;
    int entryCount;
    DateTime? lastEntryAt;
    String? lastEntryBy;

    Attendance({
        required this.status,
        this.markedBy,
        this.markedAt,
        this.entryCount = 0,
        this.lastEntryAt,
        this.lastEntryBy,
    });

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        status: json["status"] ?? '',
        markedBy: json["marked_by"],
        markedAt: json["marked_at"] == null ? null : DateTime.parse(json["marked_at"]).toLocal(),
        entryCount: json["entry_count"] ?? 0,
        lastEntryAt: json["last_entry_at"] == null ? null : DateTime.parse(json["last_entry_at"]).toLocal(),
        lastEntryBy: json["last_entry_by"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "marked_by": markedBy,
        "marked_at": markedAt?.toUtc().toIso8601String(),
        "entry_count": entryCount,
        "last_entry_at": lastEntryAt?.toUtc().toIso8601String(),
        "last_entry_by": lastEntryBy,
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
    String? timeSlot;
    String? slotLocation;

    Devotee({
        required this.id,
        required this.uniqueNumber,
        required this.name,
        required this.mobile,
        required this.gender,
        required this.age,
        required this.photo,
        required this.attendingFor,
        this.timeSlot,
        this.slotLocation,
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

class RecentScan {
    DateTime scannedAt;
    String scannedBy;

    RecentScan({
        required this.scannedAt,
        required this.scannedBy,
    });

    factory RecentScan.fromJson(Map<String, dynamic> json) => RecentScan(
        scannedAt: DateTime.parse(json["scanned_at"]),
        scannedBy: json["scanned_by"],
    );

    Map<String, dynamic> toJson() => {
        "scanned_at": scannedAt.toIso8601String(),
        "scanned_by": scannedBy,
    };
}
