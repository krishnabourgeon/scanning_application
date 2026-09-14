// To parse this JSON data, do
//
//     final eventsModel = eventsModelFromJson(jsonString);

import 'dart:convert';

EventsModel eventsModelFromJson(String str) => EventsModel.fromJson(json.decode(str));

String eventsModelToJson(EventsModel data) => json.encode(data.toJson());

class EventsModel {
    bool status;
    int totalEvents;
    int totalRegistered;
    List<Event> events;

    EventsModel({
        required this.status,
        required this.totalEvents,
        required this.totalRegistered,
        required this.events,
    });

    factory EventsModel.fromJson(Map<String, dynamic> json) => EventsModel(
        status: json["status"],
        totalEvents: json["total_events"],
        totalRegistered: json["total_registered"],
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "total_events": totalEvents,
        "total_registered": totalRegistered,
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
    };
}

class Event {
    int id;
    String name;
    String? title;
    String? description;
    String venue;
    DateTime eventDate;
    String? startTime;
    String? endTime;
    dynamic icon;
    List<String> highlights;
    int registered;
    List<Session> sessions;

    Event({
        required this.id,
        required this.name,
        required this.title,
        required this.description,
        required this.venue,
        required this.eventDate,
        required this.startTime,
        required this.endTime,
        required this.icon,
        required this.highlights,
        required this.registered,
        required this.sessions,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        description: json["description"],
        venue: json["venue"],
        eventDate: DateTime.parse(json["event_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        icon: json["icon"],
        highlights: List<String>.from(json["highlights"].map((x) => x)),
        registered: json["registered"],
        sessions: List<Session>.from(json["sessions"].map((x) => Session.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "description": description,
        "venue": venue,
        "event_date": "${eventDate.year.toString().padLeft(4, '0')}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "icon": icon,
        "highlights": List<dynamic>.from(highlights.map((x) => x)),
        "registered": registered,
        "sessions": List<dynamic>.from(sessions.map((x) => x.toJson())),
    };
}

class Session {
    String sessionName;
    String startTime;
    String endTime;
    String capacityText;

    Session({
        required this.sessionName,
        required this.startTime,
        required this.endTime,
        required this.capacityText,
    });

    factory Session.fromJson(Map<String, dynamic> json) => Session(
        sessionName: json["session_name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        capacityText: json["capacity_text"],
    );

    Map<String, dynamic> toJson() => {
        "session_name": sessionName,
        "start_time": startTime,
        "end_time": endTime,
        "capacity_text": capacityText,
    };
}
