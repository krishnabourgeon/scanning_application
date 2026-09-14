// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../models/events_model.dart';
// import '../providers/auth_provider.dart';
// import '../providers/event_provider.dart';
// import '../services/provider_helper_class.dart';
// import '../theme/app_theme.dart';
// import 'qr_scanner_screen.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});a

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<EventProvider>().getEvents();
//     });
//   }

//   Future<void> _refreshEvents() async {
//     await context.read<EventProvider>().getEvents();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final eventProvider = context.watch<EventProvider>();
//     final events = eventProvider.eventsList;
//     final isLoading = eventProvider.loaderState == LoaderState.loading;
//     final isError = eventProvider.loaderState == LoaderState.error ||
//         eventProvider.loaderState == LoaderState.networkErr;

//     final totalEvents =
//         eventProvider.eventsResponse?.totalEvents ?? events.length;
//     final totalRegistered = eventProvider.eventsResponse?.totalRegistered ??
//         events.fold<int>(0, (sum, e) => sum + e.registered);

//     return Scaffold(
//       backgroundColor: AppColors.cream,
//       body: SafeArea(
//         child: RefreshIndicator(
//           color: AppColors.brown,
//           backgroundColor: AppColors.card,
//           onRefresh: _refreshEvents,
//           child: CustomScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               SliverToBoxAdapter(
//                 child: _Header(
//                   username: auth.name,
//                   onLogout: () => auth.logout(),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: _StatsRow(
//                   eventCount: totalEvents,
//                   registered: totalRegistered,
//                 ),
//               ),
//               SliverPadding(
//                 padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
//                 sliver: SliverToBoxAdapter(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Your events',
//                         style:
//                             Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                   fontSize: 19,
//                                 ),
//                       ),
//                       if (isLoading && events.isNotEmpty)
//                         const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: AppColors.brown,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (isLoading && events.isEmpty)
//                 const SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(32),
//                       child: CircularProgressIndicator(
//                         color: AppColors.brown,
//                       ),
//                     ),
//                   ),
//                 )
//               else if (isError && events.isEmpty)
//                 SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: _ErrorState(onRetry: _refreshEvents),
//                 )
//               else if (events.isEmpty)
//                 const SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: _EmptyState(),
//                 )
//               else
//                 SliverPadding(
//                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                   sliver: SliverList.separated(
//                     itemCount: events.length,
//                     separatorBuilder: (_, _) => const SizedBox(height: 14),
//                     itemBuilder: (context, i) => _EventCard(event: events[i]),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _Header extends StatelessWidget {
//   final String? username;
//   final VoidCallback onLogout;
//   const _Header({required this.username, required this.onLogout});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: AppColors.brown,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               (username?.isNotEmpty ?? false) ? username![0].toUpperCase() : 'V',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.cream,
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Namaskaram',
//                   style: TextStyle(
//                     fontSize: 12.5,
//                     color: AppColors.muted,
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   username ?? 'Volunteer',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontSize: 21,
//                       ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             tooltip: 'Log out',
//             icon: const Icon(Icons.logout_rounded, color: AppColors.rust),
//             onPressed: onLogout,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatsRow extends StatelessWidget {
//   final int eventCount;
//   final int registered;
//   const _StatsRow({
//     required this.eventCount,
//     required this.registered,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.card,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: AppColors.divider),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         child: Row(
//           children: [
//             Expanded(
//               child: _StatItem(
//                 value: '$eventCount',
//                 label: 'Events',
//               ),
//             ),
//             _divider(),
//             Expanded(
//               child: _StatItem(
//                 value: '$registered',
//                 label: 'Registered',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _divider() => Container(
//         width: 1,
//         height: 34,
//         color: AppColors.divider,
//       );
// }

// class _StatItem extends StatelessWidget {
//   final String value;
//   final String label;
//   const _StatItem({required this.value, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//             color: AppColors.brown,
//           ),
//         ),
//         const SizedBox(height: 3),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
//         ),
//       ],
//     );
//   }
// }

// enum _EventStatus { live, upcoming, past }

// class _EventCard extends StatelessWidget {
//   final Event event;
//   const _EventCard({required this.event});

//   _EventStatus get _status {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final eventDay = DateTime(
//       event.eventDate.year,
//       event.eventDate.month,
//       event.eventDate.day,
//     );

//     if (eventDay.isAtSameMomentAs(today)) {
//       return _EventStatus.live;
//     }
//     if (eventDay.isAfter(today)) return _EventStatus.upcoming;
//     return _EventStatus.past;
//   }

//   Color _statusColor(_EventStatus s) {
//     switch (s) {
//       case _EventStatus.live:
//         return AppColors.success;
//       case _EventStatus.upcoming:
//         return AppColors.gold;
//       case _EventStatus.past:
//         return AppColors.muted;
//     }
//   }

//   String _statusLabel(_EventStatus s) {
//     switch (s) {
//       case _EventStatus.live:
//         return 'Live today';
//       case _EventStatus.upcoming:
//         return 'Upcoming';
//       case _EventStatus.past:
//         return 'Completed';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dateFormatted = DateFormat('EEE, MMM d').format(event.eventDate);
//     final timeFormatted =
//         (event.startTime != null && event.startTime!.trim().isNotEmpty)
//             ? ' · ${event.startTime}'
//             : '';
//     final dateStr = '$dateFormatted$timeFormatted';
//     final status = _status;
//     final statusColor = _statusColor(status);
//     final isPast = status == _EventStatus.past;
//     final title = (event.title != null && event.title!.trim().isNotEmpty)
//         ? event.title!
//         : event.name;

//     return Card(
//       margin: EdgeInsets.zero,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(18),
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => QrScannerScreen(eventId: event.id.toString()),
//             ),
//           );
//         },
//         child: Opacity(
//           opacity: isPast ? 0.72 : 1,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 46,
//                       height: 46,
//                       decoration: BoxDecoration(
//                         color: AppColors.rust.withValues(alpha: 0.10),
//                         borderRadius: BorderRadius.circular(13),
//                       ),
//                       child: const Icon(Icons.event, color: AppColors.rust),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             title,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.ink,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 3),
//                           Text(
//                             '${event.venue} · $dateStr',
//                             style: const TextStyle(
//                               fontSize: 12.5,
//                               color: AppColors.muted,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: AppColors.gold.withValues(alpha: 0.12),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Icon(
//                         Icons.qr_code_scanner,
//                         color: AppColors.brown,
//                         size: 20,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 Row(
//                   children: [
//                     Container(
//                       padding:
//                           const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: statusColor.withValues(alpha: 0.12),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 6,
//                             height: 6,
//                             decoration: BoxDecoration(
//                               color: statusColor,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Text(
//                             _statusLabel(status),
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w700,
//                               color: statusColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     Text(
//                       '${event.registered} registered',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: AppColors.muted,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _EmptyState extends StatelessWidget {
//   const _EmptyState();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 72,
//               height: 72,
//               decoration: BoxDecoration(
//                 color: AppColors.gold.withValues(alpha: 0.15),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.event_busy,
//                 size: 32,
//                 color: AppColors.rust,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No events yet',
//               style: Theme.of(context)
//                   .textTheme
//                   .headlineSmall
//                   ?.copyWith(fontSize: 17),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               'Events you\'re assigned to will show up here.\nPull down to refresh.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 13, color: AppColors.muted),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ErrorState extends StatelessWidget {
//   final Future<void> Function() onRetry;
//   const _ErrorState({required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 72,
//               height: 72,
//               decoration: BoxDecoration(
//                 color: AppColors.rust.withValues(alpha: 0.15),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.cloud_off_rounded,
//                 size: 32,
//                 color: AppColors.rust,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Failed to load events',
//               style: Theme.of(context)
//                   .textTheme
//                   .headlineSmall
//                   ?.copyWith(fontSize: 17),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               'Please check your network connection and try again.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 13, color: AppColors.muted),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh, size: 18),
//               label: const Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.brown,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/events_model.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../services/provider_helper_class.dart';
import '../theme/app_theme.dart';
import 'event_report_screen.dart';
import 'qr_scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().getEvents();
    });
  }

  Future<void> _refreshEvents() async {
    await context.read<EventProvider>().getEvents();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final eventProvider = context.watch<EventProvider>();
    final events = eventProvider.eventsList;
    final isLoading = eventProvider.loaderState == LoaderState.loading;
    final isError = eventProvider.loaderState == LoaderState.error ||
        eventProvider.loaderState == LoaderState.networkErr;

    final totalEvents =
        eventProvider.eventsResponse?.totalEvents ?? events.length;
    final totalRegistered = eventProvider.eventsResponse?.totalRegistered ??
        events.fold<int>(0, (sum, e) => sum + e.registered);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.brown,
          backgroundColor: AppColors.card,
          onRefresh: _refreshEvents,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _Header(
                  username: auth.name,
                  onLogout: () => auth.logout(),
                ),
              ),
              SliverToBoxAdapter(
                child: _StatsRow(
                  eventCount: totalEvents,
                  registered: totalRegistered,
                ),
              ),
              SliverToBoxAdapter(
                child: _ReportSection(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EventReportScreen()),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your events',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 19,
                                ),
                      ),
                      if (isLoading && events.isNotEmpty)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.brown,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isLoading && events.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                )
              else if (isError && events.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorState(onRetry: _refreshEvents),
                )
              else if (events.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList.separated(
                    itemCount: events.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, i) => _EventCard(event: events[i]),
                  ),
                ),
            ],
          ),
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
                const Text(
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
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.brown,
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

class _ReportSection extends StatelessWidget {
  final VoidCallback onTap;
  const _ReportSection({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.divider),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.brown.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.brown,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance Report',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Check-in summary across all events',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _EventStatus { live, upcoming, past }

class _EventCard extends StatelessWidget {
  final Event event;
  const _EventCard({required this.event});

  _EventStatus get _status {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(
      event.eventDate.year,
      event.eventDate.month,
      event.eventDate.day,
    );

    if (eventDay.isAtSameMomentAs(today)) {
      return _EventStatus.live;
    }
    if (eventDay.isAfter(today)) return _EventStatus.upcoming;
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
        return 'Live today';
      case _EventStatus.upcoming:
        return 'Upcoming';
      case _EventStatus.past:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('EEE, MMM d').format(event.eventDate);
    final timeFormatted =
        (event.startTime != null && event.startTime!.trim().isNotEmpty)
            ? ' · ${event.startTime}'
            : '';
    final dateStr = '$dateFormatted$timeFormatted';
    final status = _status;
    final statusColor = _statusColor(status);
    final isPast = status == _EventStatus.past;
    final title = (event.title != null && event.title!.trim().isNotEmpty)
        ? event.title!
        : event.name;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QrScannerScreen(eventId: event.id.toString()),
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
                            title,
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
                      '${event.registered} registered',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
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
              child: const Icon(
                Icons.event_busy,
                size: 32,
                color: AppColors.rust,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No events yet',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 6),
            const Text(
              'Events you\'re assigned to will show up here.\nPull down to refresh.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _ErrorState({required this.onRetry});

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
                color: AppColors.rust.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 32,
                color: AppColors.rust,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load events',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 6),
            const Text(
              'Please check your network connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}