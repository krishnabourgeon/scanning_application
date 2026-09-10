// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../models/event.dart';
// import '../providers/auth_provider.dart';
// import '../providers/event_provider.dart';
// import '../theme/app_theme.dart';
// import 'qr_scanner_screen.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final events = context.watch<EventProvider>().events;

//     return Scaffold(
//       backgroundColor: AppColors.cream,
//       appBar: AppBar(
//         title: const Text('Events'),
//         actions: [
//           IconButton(
//             tooltip: 'Log out',
//             icon: const Icon(Icons.logout, color: AppColors.brown),
//             onPressed: () => auth.logout(),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
//               child: Text(
//                 'Welcome, ${auth.username ?? "Volunteer"}',
//                 style: const TextStyle(
//                   color: AppColors.muted,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
//                 itemCount: events.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 14),
//                 itemBuilder: (context, i) => _EventCard(event: events[i]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _EventCard extends StatelessWidget {
//   final EventModel event;
//   const _EventCard({required this.event});

//   @override
//   Widget build(BuildContext context) {
//     final progress =
//         event.totalRegistered == 0 ? 0.0 : event.checkedIn / event.totalRegistered;
//     final dateStr = DateFormat('EEE, MMM d · h:mm a').format(event.dateTime);

//     return Card(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(18),
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => QrScannerScreen(eventId: event.id),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(18),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: AppColors.gold.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.event, color: AppColors.brown),
//                   ),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           event.title,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.ink,
//                           ),
//                         ),
//                         const SizedBox(height: 3),
//                         Text(
//                           '${event.venue} · $dateStr',
//                           style: const TextStyle(
//                               fontSize: 12.5, color: AppColors.muted),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Icon(Icons.qr_code_scanner,
//                       color: AppColors.brown, size: 22),
//                 ],
//               ),
//               // const SizedBox(height: 14),
//               // ClipRRect(
//               //   borderRadius: BorderRadius.circular(6),
//               //   child: LinearProgressIndicator(
//               //     value: progress.clamp(0, 1),
//               //     minHeight: 6,
//               //     backgroundColor: AppColors.divider,
//               //     valueColor:
//               //         const AlwaysStoppedAnimation<Color>(AppColors.gold),
//               //   ),
//               // ),
//               // const SizedBox(height: 6),
//               // Text(
//               //   '${event.checkedIn} / ${event.totalRegistered} checked in',
//               //   style: const TextStyle(fontSize: 12, color: AppColors.muted),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import 'qr_scanner_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final events = context.watch<EventProvider>().events;

    final totalRegistered =
        events.fold<int>(0, (sum, e) => sum + e.totalRegistered);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Header(
                username: auth.username,
                onLogout: () => auth.logout(),
              ),
            ),
            SliverToBoxAdapter(
              child: _StatsRow(
                eventCount: events.length,
                registered: totalRegistered,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Your events',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 19,
                      ),
                ),
              ),
            ),
            if (events.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.separated(
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, i) => _EventCard(event: events[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? username;
  final VoidCallback onLogout;
  const _Header({required this.username, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.brown,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Text(
              (username?.isNotEmpty ?? false) ? username![0].toUpperCase() : 'V',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.cream,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Namaskaram',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  username ?? 'Volunteer',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 21,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout_rounded, color: AppColors.rust),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int eventCount;
  final int registered;
  const _StatsRow({
    required this.eventCount,
    required this.registered,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                value: '$eventCount',
                label: 'Events',
              ),
            ),
            _divider(),
            Expanded(
              child: _StatItem(
                value: '$registered',
                label: 'Registered',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 34,
        color: AppColors.divider,
      );
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  const _StatItem({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: valueColor ?? AppColors.brown,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
        ),
      ],
    );
  }
}

enum _EventStatus { live, upcoming, past }

class _EventCard extends StatelessWidget {
  final EventModel event;
  const _EventCard({required this.event});

  _EventStatus get _status {
    final now = DateTime.now();
    if (now.isAfter(event.dateTime) &&
        now.difference(event.dateTime).inHours <= 3) {
      return _EventStatus.live;
    }
    if (event.dateTime.isAfter(now)) return _EventStatus.upcoming;
    return _EventStatus.past;
  }

  Color _statusColor(_EventStatus s) {
    switch (s) {
      case _EventStatus.live:
        return AppColors.success;
      case _EventStatus.upcoming:
        return AppColors.gold;
      case _EventStatus.past:
        return AppColors.muted;
    }
  }

  String _statusLabel(_EventStatus s) {
    switch (s) {
      case _EventStatus.live:
        return 'Live now';
      case _EventStatus.upcoming:
        return 'Upcoming';
      case _EventStatus.past:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEE, MMM d · h:mm a').format(event.dateTime);
    final status = _status;
    final statusColor = _statusColor(status);
    final isPast = status == _EventStatus.past;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QrScannerScreen(eventId: event.id),
            ),
          );
        },
        child: Opacity(
          opacity: isPast ? 0.72 : 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.rust.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.event, color: AppColors.rust),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${event.venue} · $dateStr',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: AppColors.brown,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _statusLabel(status),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${event.totalRegistered} registered',
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.event_busy, size: 32, color: AppColors.rust),
            ),
            const SizedBox(height: 16),
            Text(
              'No events yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 6),
            const Text(
              'Events you\'re assigned to will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}