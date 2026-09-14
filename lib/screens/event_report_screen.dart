import 'package:adwaitha_sangamam/providers/event_provider.dart';
import 'package:adwaitha_sangamam/screens/event_report_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/report_model.dart';
import '../theme/app_theme.dart';

class EventReportScreen extends StatefulWidget {
  const EventReportScreen({super.key});

  @override
  State<EventReportScreen> createState() => _EventReportScreenState();
}

class _EventReportScreenState extends State<EventReportScreen> {
  // // Sample data — replace with real data once wired up.

  @override
  void initState() {
    super.initState();
    context.read<EventProvider>().getReport();
  }
  @override
  Widget build(BuildContext context) {
    List<Report> report = context.watch<EventProvider>().reportList;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _ReportHeader(
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
            if (report.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _ReportEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                sliver: SliverList.separated(
                  itemCount: report.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, i) => _ReportCard(item: report[i], reportTab: () {
                    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventReportDetailScreen(
              report: report[i],
            ),
          ),
        );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReportHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _ReportHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),
          Text(
            'Attendance Report',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 19,
                ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final Report item;
  final VoidCallback reportTab;
  const _ReportCard({required this.item, required this.reportTab});

  @override
  Widget build(BuildContext context) {
    final String eventName = item.event;
    final int total = item.totalRegistered;
    final int present = item.present;
    final int absent = item.absent;
    final int notMarked = item.notMarked;

    final marked = present + absent;
    final markedPct = total == 0 ? 0.0 : marked / total;

    return InkWell(
      onTap: reportTab,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      eventName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$total registered',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : markedPct,
                  minHeight: 6,
                  backgroundColor: AppColors.divider,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _ReportStat(
                      label: 'Present',
                      value: present,
                      color: AppColors.success,
                    ),
                  ),
                  _statDivider(),
                  Expanded(
                    child: _ReportStat(
                      label: 'Absent',
                      value: absent,
                      color: AppColors.rust,
                    ),
                  ),
                  _statDivider(),
                  Expanded(
                    child: _ReportStat(
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
      ),
    );
  }

  Widget _statDivider() => Container(
        width: 1,
        height: 30,
        color: AppColors.divider,
      );
}

class _ReportStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _ReportStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    );
  }
}

class _ReportEmptyState extends StatelessWidget {
  const _ReportEmptyState();

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
                Icons.bar_chart_rounded,
                size: 32,
                color: AppColors.rust,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No report data',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 6),
            const Text(
              'Attendance numbers will show up here\nonce events have registrations.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}