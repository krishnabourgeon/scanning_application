enum EntryStatus { eligible, alreadyCheckedIn, notRegistered }

class AttendeeModel {
  final String id;
  final String name;
  final String phone;
  final String ticketType; // e.g. "Delegate", "Guest", "VIP"
  final String qrCode;
  final EntryStatus status;
  final String? photoUrl;

  const AttendeeModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.ticketType,
    required this.qrCode,
    required this.status,
    this.photoUrl,
  });
}
