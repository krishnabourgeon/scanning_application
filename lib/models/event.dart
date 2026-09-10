class EventModel {
  final String id;
  final String title;
  final String venue;
  final DateTime dateTime;
  final int checkedIn;
  final int totalRegistered;

  const EventModel({
    required this.id,
    required this.title,
    required this.venue,
    required this.dateTime,
    required this.checkedIn,
    required this.totalRegistered,
  });
}
