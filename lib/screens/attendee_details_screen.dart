// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/attendee.dart';
// import '../providers/event_provider.dart';
// import '../theme/app_theme.dart';

// class AttendeeDetailsScreen extends StatelessWidget {
//   final String eventId;
//   final String scannedCode;
//   final AttendeeModel? attendee;

//   const AttendeeDetailsScreen({
//     super.key,
//     required this.eventId,
//     required this.scannedCode,
//     required this.attendee,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final a = attendee;

//     return Scaffold(
//       backgroundColor: AppColors.cream,
//       appBar: AppBar(title: const Text('Ticket Details')),
//       body: SafeArea(
//         child: a == null
//             ? _NotFoundView(scannedCode: scannedCode)
//             : _AttendeeView(eventId: eventId, attendee: a),
//       ),
//     );
//   }
// }

// class _NotFoundView extends StatelessWidget {
//   final String scannedCode;
//   const _NotFoundView({required this.scannedCode});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(28),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.error_outline, color: AppColors.danger, size: 64),
//             const SizedBox(height: 16),
//             const Text(
//               'Ticket not recognized',
//               style: TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Code "$scannedCode" doesn\'t match any registered ticket.',
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: AppColors.muted),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.brown,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 2,
//               ),
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Scan Again'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AttendeeView extends StatelessWidget {
//   final String eventId;
//   final AttendeeModel attendee;
//   const _AttendeeView({required this.eventId, required this.attendee});

//   @override
//   Widget build(BuildContext context) {
//     final isEligible = attendee.status == EntryStatus.eligible;
//     final alreadyIn = attendee.status == EntryStatus.alreadyCheckedIn;

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           _StatusBanner(status: attendee.status),
//           const SizedBox(height: 20),
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: AppColors.gold.withValues(alpha: 0.18),
//                     child: Text(
//                       attendee.name.isNotEmpty
//                           ? attendee.name[0].toUpperCase()
//                           : '?',
//                       style: const TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.brown,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 14),
//                   Text(
//                     attendee.name,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.ink,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: AppColors.brown.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       attendee.ticketType,
//                       style: const TextStyle(
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.brown,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 18),
//                   const Divider(color: AppColors.divider),
//                   const SizedBox(height: 12),
//                   _DetailRow(icon: Icons.phone_outlined, label: 'Phone', value: attendee.phone),
//                   const SizedBox(height: 10),
//                   _DetailRow(
//                       icon: Icons.confirmation_number_outlined,
//                       label: 'Ticket ID',
//                       value: attendee.qrCode),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 32),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(Icons.cancel_outlined, color: AppColors.danger),
//                   label: const Text('Cancel'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: AppColors.danger,
//                     side: const BorderSide(color: AppColors.danger),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: (!isEligible)
//                       ? null
//                       : () {
//                           context
//                               .read<EventProvider>()
//                               .markAttendance(eventId, attendee.id);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('${attendee.name} marked as entered'),
//                               backgroundColor: AppColors.success,
//                             ),
//                           );
//                           Navigator.of(context).pop();
//                         },
//                   icon: const Icon(Icons.check_circle_outline),
//                   label: Text(alreadyIn ? 'Already Entered' : 'Submit'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         isEligible ? AppColors.success : AppColors.muted,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatusBanner extends StatelessWidget {
//   final EntryStatus status;
//   const _StatusBanner({required this.status});

//   @override
//   Widget build(BuildContext context) {
//     late final Color color;
//     late final IconData icon;
//     late final String text;

//     switch (status) {
//       case EntryStatus.eligible:
//         color = AppColors.success;
//         icon = Icons.check_circle;
//         text = 'Eligible — allow entry';
//         break;
//       case EntryStatus.alreadyCheckedIn:
//         color = AppColors.gold;
//         icon = Icons.info;
//         text = 'Already checked in earlier';
//         break;
//       case EntryStatus.notRegistered:
//         color = AppColors.danger;
//         icon = Icons.block;
//         text = 'Not registered for this event';
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.12),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: color.withValues(alpha: 0.4)),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 22),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(color: color, fontWeight: FontWeight.w700),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DetailRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   const _DetailRow({required this.icon, required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: AppColors.muted),
//         const SizedBox(width: 10),
//         Text('$label: ', style: const TextStyle(color: AppColors.muted)),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink),
//           ),
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/scan_model.dart';
import '../providers/event_provider.dart';
import '../services/provider_helper_class.dart';
import '../theme/app_theme.dart';

class AttendeeDetailsScreen extends StatefulWidget {
  final String eventId;
  final ScanModel scan;
  const AttendeeDetailsScreen({
    super.key,
    required this.eventId,
    required this.scan,
  });

  @override
  State<AttendeeDetailsScreen> createState() => _AttendeeDetailsScreenState();
}

class _AttendeeDetailsScreenState extends State<AttendeeDetailsScreen> {
  // The status currently being submitted, so only the pressed button
  // shows its own spinner instead of both.
  String? _pendingStatus;

  bool get _alreadyPresent =>
      widget.scan.attendance?.status.toLowerCase() == 'yes';
  bool get _alreadyMarked => widget.scan.attendance != null;

  Future<void> _mark(String status) async {
    setState(() => _pendingStatus = status);

    final provider = context.read<EventProvider>();
    final result = await provider.markAttendance(
      widget.scan.devotee.uniqueNumber,
      status,
    );

    if (!mounted) return;
    setState(() => _pendingStatus = null);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.markErrorMessage ?? 'Failed to mark attendance.'),
          backgroundColor: AppColors.rust,
        ),
      );
      return;
    }

    final isPresent = status.toLowerCase() == 'yes';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isPresent
              ? '${result.data.name} allowed entry.'
              : '${result.data.name} marked as not entering.',
        ),
        backgroundColor: isPresent ? AppColors.success : AppColors.rust,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final devotee = widget.scan.devotee;
    final attendance = widget.scan.attendance;
    final provider = context.watch<EventProvider>();
    final marking = provider.markState == LoaderState.loading;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        foregroundColor: AppColors.ink,
        title: const Text('Ticket Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                backgroundImage: devotee.photo.isNotEmpty
                    ? NetworkImage(devotee.photo)
                    : null,
                child: devotee.photo.isEmpty
                    ? const Icon(Icons.person, size: 40, color: AppColors.brown)
                    : null,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              devotee.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              devotee.uniqueNumber,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailRow(icon: Icons.phone, label: 'Mobile', value: devotee.mobile),
                  _DetailRow(icon: Icons.wc, label: 'Gender', value: devotee.gender),
                  _DetailRow(icon: Icons.cake, label: 'Age', value: '${devotee.age}'),
                  _DetailRow(
                    icon: Icons.event_available,
                    label: 'Attending for',
                    value: devotee.attendingFor,
                  ),
                  _DetailRow(icon: Icons.schedule, label: 'Time slot', value: devotee.timeSlot),
                  _DetailRow(
                    icon: Icons.place,
                    label: 'Slot location',
                    value: devotee.slotLocation,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_alreadyMarked)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (_alreadyPresent ? AppColors.success : AppColors.rust)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      _alreadyPresent ? Icons.check_circle : Icons.cancel,
                      color: _alreadyPresent ? AppColors.success : AppColors.rust,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Already marked ${_alreadyPresent ? 'entered' : 'not entering'}'
                        '${attendance?.markedAt != null ? ' at ${DateFormat('MMM d, h:mm a').format(attendance!.markedAt!)}' : ''}'
                        '${attendance?.markedBy?.isNotEmpty == true ? ' by ${attendance!.markedBy}' : ''}.',
                        style: const TextStyle(color: AppColors.ink, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: marking ? null : () => _mark('No'),
                        icon: _pendingStatus == 'No'
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.rust,
                                ),
                              )
                            : const Icon(Icons.close, color: AppColors.rust),
                        label: Text(
                          _pendingStatus == 'No' ? 'Marking...' : 'Not Entering',
                          style: const TextStyle(color: AppColors.rust),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.rust),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: marking ? null : () => _mark('Yes'),
                        icon: _pendingStatus == 'Yes'
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(_pendingStatus == 'Yes' ? 'Marking...' : 'Allow Entry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brown,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.rust),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            const Spacer(),
            Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
        if (!isLast) const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ],
    );
  }
}