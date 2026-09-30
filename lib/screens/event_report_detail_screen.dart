// import 'package:adwaitha_sangamam/models/report_detail_model,dart';
// import 'package:adwaitha_sangamam/models/scan_model.dart';
// import 'package:adwaitha_sangamam/providers/event_provider.dart';
// import 'package:adwaitha_sangamam/services/provider_helper_class.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/report_model.dart';
// import '../theme/app_theme.dart';

// enum AttendeeStatus { yes, no, notMarked }

// class Attendee {
//   final String name;
//   final String phone;
//   final AttendeeStatus status;
//   const Attendee({required this.name, required this.phone, required this.status});
// }

// class EventReportDetailScreen extends StatefulWidget {
//   final Report report;
//   const EventReportDetailScreen({super.key, required this.report});

//   @override
//   State<EventReportDetailScreen> createState() => _EventReportDetailScreenState();
// }

// class _EventReportDetailScreenState extends State<EventReportDetailScreen> {
//   AttendeeStatus? _filter;
//   String _query = '';

//     @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Fetch report for this event when screen opens
//       context.read<EventProvider>().getReportDetail(widget.report.event);
//     });
//   }

//   // // TODO: replace with real data from provider once wired up.
//   // final List<Attendee> _attendees = const [
//   //   Attendee(name: 'Anil Kumar', phone: '9876543210', status: AttendeeStatus.present),
//   //   Attendee(name: 'Divya Menon', phone: '9876500011', status: AttendeeStatus.absent),
//   //   Attendee(name: 'Rahul Nair', phone: '9845098450', status: AttendeeStatus.notMarked),
//   // ];

//   List<ReportList> get _filtered {
//     final provider = context.read<EventProvider>();
//     return provider.reportDetailList.where((devotee) {
//       final matchesFilter = _filter == null || devotee.status == _filter;
//       final matchesQuery = _query.isEmpty ||
//           devotee.name.toLowerCase().contains(_query.toLowerCase()) ||
//           devotee.mobile.contains(_query);
//       return matchesFilter && matchesQuery;
//     }).toList();
//   }

//   AttendeeStatus _statusFrom(String status){
//     switch(status){
//       case "yes":
//         return AttendeeStatus.yes;
//       case "no":
//         return AttendeeStatus.no;
//       case "not_marked":
//         return AttendeeStatus.notMarked;
//       default:
//         return AttendeeStatus.notMarked;
//     }

//   }
//   @override
//   Widget build(BuildContext context) {
//     // final report = widget.report;
//     // final total = report.totalRegistered;
//     // final present = report.present;
//     // final absent = report.absent;
//     // final notMarked = report.notMarked;
//     // final markedPct = total == 0 ? 0.0 : (present + absent) / total;

 
//     return Consumer<EventProvider>(
//       builder: (context,provider,child) {
//         if(provider.loaderState == LoaderState.loading){
//           return const Center(child: CircularProgressIndicator(),);
//         } else if{provider.loaderState == LoaderState.loaded}{
          
//         }
//         return Scaffold(
//           backgroundColor: AppColors.cream,
//           body: SafeArea(
//             child: CustomScrollView(
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: _DetailHeader(
//                     eventName: report.event,
//                     onBack: () => Navigator.of(context).pop(),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
//                     child: _SummaryCard(
//                       total: total,
//                       present: present,
//                       absent: absent,
//                       notMarked: notMarked,
//                       markedPct: markedPct,
//                     ),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
//                     child: _SearchAndFilterBar(
//                       query: _query,
//                       onQueryChanged: (v) => setState(() => _query = v),
//                       filter: _filter,
//                       onFilterChanged: (v) => setState(() => _filter = v),
//                     ),
//                   ),
//                 ),
//                 if (_filtered.isEmpty)
//                   const SliverFillRemaining(
//                     hasScrollBody: false,
//                     child: _AttendeeEmptyState(),
//                   )
//                 else
//                   SliverPadding(
//                     padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                     sliver: SliverList.separated(
//                       itemCount: _filtered.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 10),
//                       itemBuilder: (context, i) => _AttendeeTile(attendee: _filtered[i]),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       }
//     );
//   }
// }

// class _DetailHeader extends StatelessWidget {
//   final String eventName;
//   final VoidCallback onBack;
//   const _DetailHeader({required this.eventName, required this.onBack});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
//             onPressed: onBack,
//           ),
//           const SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               eventName,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 19),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SummaryCard extends StatelessWidget {
//   final int total;
//   final int present;
//   final int absent;
//   final int notMarked;
//   final double markedPct;

//   const _SummaryCard({
//     required this.total,
//     required this.present,
//     required this.absent,
//     required this.notMarked,
//     required this.markedPct,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   '$total',
//                   style: const TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.w800,
//                     color: AppColors.ink,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 4),
//                   child: Text(
//                     'registered',
//                     style: const TextStyle(fontSize: 13, color: AppColors.muted),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(6),
//               child: LinearProgressIndicator(
//                 value: total == 0 ? 0 : markedPct,
//                 minHeight: 6,
//                 backgroundColor: AppColors.divider,
//                 color: AppColors.success,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _SummaryStat(label: 'Present', value: present, color: AppColors.success),
//                 ),
//                 _divider(),
//                 Expanded(
//                   child: _SummaryStat(label: 'Absent', value: absent, color: AppColors.rust),
//                 ),
//                 _divider(),
//                 Expanded(
//                   child: _SummaryStat(label: 'Not marked', value: notMarked, color: AppColors.muted),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _divider() => Container(width: 1, height: 30, color: AppColors.divider);
// }

// class _SummaryStat extends StatelessWidget {
//   final String label;
//   final int value;
//   final Color color;
//   const _SummaryStat({required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           '$value',
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: color),
//         ),
//         const SizedBox(height: 3),
//         Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
//       ],
//     );
//   }
// }

// class _SearchAndFilterBar extends StatelessWidget {
//   final String query;
//   final ValueChanged<String> onQueryChanged;
//   final AttendeeStatus? filter;
//   final ValueChanged<AttendeeStatus?> onFilterChanged;

//   const _SearchAndFilterBar({
//     required this.query,
//     required this.onQueryChanged,
//     required this.filter,
//     required this.onFilterChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           onChanged: onQueryChanged,
//           decoration: InputDecoration(
//             hintText: 'Search by name or phone',
//             prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: AppColors.divider),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: AppColors.divider),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 34,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               _FilterChip(label: 'All', selected: filter == null, onTap: () => onFilterChanged(null)),
//               const SizedBox(width: 8),
//               _FilterChip(
//                 label: 'Present',
//                 color: AppColors.success,
//                 selected: filter == AttendeeStatus.present,
//                 onTap: () => onFilterChanged(AttendeeStatus.present),
//               ),
//               const SizedBox(width: 8),
//               _FilterChip(
//                 label: 'Absent',
//                 color: AppColors.rust,
//                 selected: filter == AttendeeStatus.absent,
//                 onTap: () => onFilterChanged(AttendeeStatus.absent),
//               ),
//               const SizedBox(width: 8),
//               _FilterChip(
//                 label: 'Not marked',
//                 color: AppColors.muted,
//                 selected: filter == AttendeeStatus.notMarked,
//                 onTap: () => onFilterChanged(AttendeeStatus.notMarked),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FilterChip extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final Color? color;
//   final VoidCallback onTap;
//   const _FilterChip({required this.label, required this.selected, required this.onTap, this.color});

//   @override
//   Widget build(BuildContext context) {
//     final Color base = color ?? AppColors.brown;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: selected ? base.withValues(alpha: 0.12) : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: selected ? base.withValues(alpha: 0.4) : AppColors.divider),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 12.5,
//             fontWeight: FontWeight.w700,
//             color: selected ? base : AppColors.muted,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _AttendeeTile extends StatelessWidget {
//   final Attendee attendee;
//   const _AttendeeTile({required this.attendee});

//   Color get _statusColor => switch (attendee.status) {
//         AttendeeStatus.present => AppColors.success,
//         AttendeeStatus.absent => AppColors.rust,
//         AttendeeStatus.notMarked => AppColors.muted,
//       };

//   String get _statusLabel => switch (attendee.status) {
//         AttendeeStatus.present => 'Present',
//         AttendeeStatus.absent => 'Absent',
//         AttendeeStatus.notMarked => 'Not marked',
//       };

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: AppColors.gold.withValues(alpha: 0.15),
//               child: Text(
//                 attendee.name.isNotEmpty ? attendee.name[0].toUpperCase() : '?',
//                 style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brown),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     attendee.name,
//                     style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.ink),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     attendee.phone,
//                     style: const TextStyle(fontSize: 12, color: AppColors.muted),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: _statusColor.withValues(alpha: 0.12),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 _statusLabel,
//                 style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _statusColor),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AttendeeEmptyState extends StatelessWidget {
//   const _AttendeeEmptyState();

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
//               child: const Icon(Icons.person_search_rounded, size: 32, color: AppColors.rust),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No attendees found',
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 17),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               'Try a different search or filter.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 13, color: AppColors.muted),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:adwaitha_sangamam/models/report_detail_model,dart';
import 'package:adwaitha_sangamam/models/report_model.dart';
import 'package:adwaitha_sangamam/providers/event_provider.dart';
import 'package:adwaitha_sangamam/services/provider_helper_class.dart';
import 'package:adwaitha_sangamam/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AttendeeStatus {
  present,
  absent,
  notMarked,
}

class EventReportDetailScreen extends StatefulWidget {
  final Report report;

  const EventReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  State<EventReportDetailScreen> createState() =>
      _EventReportDetailScreenState();
}

class _EventReportDetailScreenState
    extends State<EventReportDetailScreen> {
  AttendeeStatus? _filter;
  String _query = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().getReportDetail(
            widget.report.event,
          );
    });
  }

  AttendeeStatus _statusFromApi(String status) {
    switch (status.toLowerCase()) {
      case 'yes':
      case 'present':
        return AttendeeStatus.present;

      case 'no':
      case 'absent':
        return AttendeeStatus.absent;

      default:
        return AttendeeStatus.notMarked;
    }
  }

  List<ReportList> _filtered(EventProvider provider) {
    return provider.reportDetailList.where((devotee) {
      final matchesFilter =
          _filter == null ||
          _statusFromApi(devotee.status) == _filter;

      final matchesQuery =
          _query.isEmpty ||
          devotee.name.toLowerCase().contains(
                _query.toLowerCase(),
              ) ||
          devotee.mobile.contains(_query);

      return matchesFilter && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        final report = widget.report;

        final summary =
            provider.reportDetailResponse?.summary;

        final total =
            summary?.totalRegistered ?? report.totalRegistered;

        final present =
            summary?.present ?? report.present;

        final absent =
            summary?.absent ?? report.absent;

        final notMarked =
            summary?.notMarked ?? report.notMarked;

        final markedPct =
            total == 0 ? 0.0 : (present + absent) / total;

        return Scaffold(
          backgroundColor: AppColors.cream,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _DetailHeader(
                    eventName: report.event,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                ),

                if (provider.loaderState ==
                    LoaderState.loading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (provider.loaderState ==
                    LoaderState.error)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'Unable to load report details',
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        16,
                      ),
                      child: _SummaryCard(
                        total: total,
                        present: present,
                        absent: absent,
                        notMarked: notMarked,
                        markedPct: markedPct,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        12,
                      ),
                      child: _SearchAndFilterBar(
                        query: _query,
                        onQueryChanged: (v) {
                          setState(() => _query = v);
                        },
                        filter: _filter,
                        onFilterChanged: (v) {
                          setState(() => _filter = v);
                        },
                      ),
                    ),
                  ),

                  if (_filtered(provider).isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _AttendeeEmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        24,
                      ),
                      sliver: SliverList.separated(
                        itemCount: _filtered(provider).length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          return _AttendeeTile(
                            attendee: _filtered(provider)[i],
                          );
                        },
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final String eventName;
  final VoidCallback onBack;

  const _DetailHeader({
    required this.eventName,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.ink,
            ),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              eventName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 19),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int total;
  final int present;
  final int absent;
  final int notMarked;
  final double markedPct;

  const _SummaryCard({
    required this.total,
    required this.present,
    required this.absent,
    required this.notMarked,
    required this.markedPct,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$total',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    'registered',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: markedPct,
                minHeight: 6,
                backgroundColor: AppColors.divider,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    label: 'Present',
                    value: present,
                    color: AppColors.success,
                  ),
                ),
                _divider(),
                Expanded(
                  child: _SummaryStat(
                    label: 'Absent',
                    value: absent,
                    color: AppColors.rust,
                  ),
                ),
                _divider(),
                Expanded(
                  child: _SummaryStat(
                    label: 'Not marked',
                    value: notMarked,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 30,
      color: AppColors.divider,
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;
  final AttendeeStatus? filter;
  final ValueChanged<AttendeeStatus?> onFilterChanged;

  const _SearchAndFilterBar({
    required this.query,
    required this.onQueryChanged,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Search by name or phone',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.muted,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.divider,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.divider,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(
                label: 'All',
                selected: filter == null,
                onTap: () => onFilterChanged(null),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Present',
                color: AppColors.success,
                selected: filter == AttendeeStatus.present,
                onTap: () => onFilterChanged(
                  AttendeeStatus.present,
                ),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Absent',
                color: AppColors.rust,
                selected: filter == AttendeeStatus.absent,
                onTap: () => onFilterChanged(
                  AttendeeStatus.absent,
                ),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Not marked',
                color: AppColors.muted,
                selected: filter == AttendeeStatus.notMarked,
                onTap: () => onFilterChanged(
                  AttendeeStatus.notMarked,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final base = color ?? AppColors.brown;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? base.withValues(alpha: 0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? base.withValues(alpha: 0.4)
                : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: selected ? base : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

class _AttendeeTile extends StatelessWidget {
  final ReportList attendee;

  const _AttendeeTile({
    required this.attendee,
  });

  AttendeeStatus get _status {
    switch (attendee.status.toLowerCase()) {
      case 'yes':
      case 'present':
        return AttendeeStatus.present;

      case 'no':
      case 'absent':
        return AttendeeStatus.absent;

      default:
        return AttendeeStatus.notMarked;
    }
  }

  Color get _statusColor {
    switch (_status) {
      case AttendeeStatus.present:
        return AppColors.success;

      case AttendeeStatus.absent:
        return AppColors.rust;

      case AttendeeStatus.notMarked:
        return AppColors.muted;
    }
  }

  String get _statusLabel {
    switch (_status) {
      case AttendeeStatus.present:
        return 'Present';

      case AttendeeStatus.absent:
        return 'Absent';

      case AttendeeStatus.notMarked:
        return 'Not marked';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.gold.withValues(
                alpha: 0.15,
              ),
              child: Text(
                attendee.name.isNotEmpty
                    ? attendee.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.brown,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attendee.name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    attendee.mobile,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _statusLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendeeEmptyState extends StatelessWidget {
  const _AttendeeEmptyState();

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
                Icons.person_search_rounded,
                size: 32,
                color: AppColors.rust,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No attendees found',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different search or filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






