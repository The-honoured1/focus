import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../features/focus/session_history_provider.dart';
import '../../features/streak/streak_provider.dart';
import '../../models/session.dart';
import '../../core/theme.dart';
import 'package:intl/intl.dart';
import '../widgets/weekly_bar_chart.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionHistoryProvider);
    final totalFocusTime = sessions
        .fold(0, (sum, s) => sum + s.durationSeconds);
    
    final successfulSessions = sessions.where((s) => s.status == SessionStatus.completed).length;
    final streak = ref.watch(streakProvider).currentStreak;

    // Calculate daily minutes for the last 7 days
    final now = DateTime.now();
    final weekDays = List.generate(7, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i)));
    
    final dailyMinutes = weekDays.map((day) {
      final dayEnd = day.add(const Duration(days: 1));
      return sessions
          .where((s) => s.startTime.isAfter(day) && s.startTime.isBefore(dayEnd))
          .fold(0.0, (sum, s) => sum + (s.durationSeconds / 60));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('PERFORMANCE', style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _MetricRow(
                    label1: 'TOTAL TIME',
                    value1: '${totalFocusTime ~/ 3600}h ${(totalFocusTime % 3600) ~/ 60}m',
                    label2: 'SESSIONS',
                    value2: successfulSessions.toString(),
                  ),
                  const SizedBox(height: 16),
                  _MetricRow(
                    label1: 'STREAK',
                    value1: '$streak DAYS',
                    label2: 'COMPLETED',
                    value2: successfulSessions.toString(),
                  ),
                  const SizedBox(height: 24),
                  WeeklyBarChart(dailyMinutes: dailyMinutes, weekDays: weekDays),
                ],
              ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'LOG HISTORY', 
                style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 4, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final session = sessions.reversed.toList()[index];
                final isSuccess = session.status == SessionStatus.completed;
                final dateStr = DateFormat('MMM dd, HH:mm').format(session.startTime);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.glassBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isSuccess ? AppColors.primary : AppColors.error).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSuccess ? Icons.check_rounded : Icons.close_rounded,
                          color: isSuccess ? AppColors.primary : AppColors.error,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isSuccess ? 'Focus Session' : 'Partial Session', style: Theme.of(context).textTheme.bodyLarge),
                            Text(dateStr, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Text(
                        '${session.durationSeconds ~/ 60}m',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
              },
              childCount: sessions.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  const _MetricRow({
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MetricCard(label: label1, value: value1)),
        const SizedBox(width: 16),
        Expanded(child: _MetricCard(label: label2, value: value2)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
        ],
      ),
    );
  }
}
