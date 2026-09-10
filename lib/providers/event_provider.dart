import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/attendee.dart';

class EventProvider extends ChangeNotifier {
  final List<EventModel> _events = [
    EventModel(
      id: 'evt1',
      title: 'Adwaitha Sangamam — Inaugural Session',
      venue: 'Main Auditorium, Thrissur',
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      checkedIn: 128,
      totalRegistered: 400,
    ),
    EventModel(
      id: 'evt2',
      title: 'Panel: Many Voices, One Truth',
      venue: 'Conference Hall B',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      checkedIn: 40,
      totalRegistered: 250,
    ),
    EventModel(
      id: 'evt3',
      title: 'Closing Ceremony & Prasadam',
      venue: 'Temple Grounds',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      checkedIn: 0,
      totalRegistered: 500,
    ),
  ];

  // Mock ticket database keyed by QR code value. Replace with an API call.
  final Map<String, AttendeeModel> _ticketDb = {
    'AS-0001': const AttendeeModel(
      id: 'AS-0001',
      name: 'Anagha Menon',
      phone: '+91 98765 43210',
      ticketType: 'Delegate',
      qrCode: 'AS-0001',
      status: EntryStatus.eligible,
    ),
    'AS-0002': const AttendeeModel(
      id: 'AS-0002',
      name: 'Ravi Varma',
      phone: '+91 98450 11223',
      ticketType: 'VIP',
      qrCode: 'AS-0002',
      status: EntryStatus.alreadyCheckedIn,
    ),
  };

  List<EventModel> get events => List.unmodifiable(_events);

  EventModel eventById(String id) => _events.firstWhere((e) => e.id == id);

  /// Looks up a scanned QR value against the ticket database.
  /// Returns null if no matching ticket exists at all.
  AttendeeModel? lookupByQr(String code) {
    return _ticketDb[code];
  }

  /// Marks the attendee as checked in for the given event.
  /// No-ops if the ticket is unknown or already checked in, so calling this
  /// more than once for the same ticket never double-counts checkedIn.
  void markAttendance(String eventId, String attendeeId) {
    final ticket = _ticketDb[attendeeId];
    if (ticket == null || ticket.status == EntryStatus.alreadyCheckedIn) {
      return;
    }

    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx == -1) return;
    final e = _events[idx];
    _events[idx] = EventModel(
      id: e.id,
      title: e.title,
      venue: e.venue,
      dateTime: e.dateTime,
      checkedIn: e.checkedIn + 1,
      totalRegistered: e.totalRegistered,
    );

    _ticketDb[attendeeId] = AttendeeModel(
      id: ticket.id,
      name: ticket.name,
      phone: ticket.phone,
      ticketType: ticket.ticketType,
      qrCode: ticket.qrCode,
      status: EntryStatus.alreadyCheckedIn,
      photoUrl: ticket.photoUrl,
    );
    notifyListeners();
  }
}
