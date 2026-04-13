import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import 'package:intl/intl.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<double> dailyMinutes;
  final List<DateTime> weekDays;

  const WeeklyBarChart({
    super.key, 
    required this.dailyMinutes,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    final double maxMinutes = dailyMinutes.reduce((a, b) => a > b ? a : b);
    final double chartMax = maxMinutes > 60 ? maxMinutes + 20 : 60;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEEKLY PROGRESS (MINS)',
            style: GoogleFonts.inter(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final double minutes = dailyMinutes[index];
                final double heightFactor = minutes / chartMax;
                final DateTime date = weekDays[index];
                final bool isToday = DateUtils.isSameDay(date, DateTime.now());

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500 + (index * 100)),
                            curve: Curves.easeOutCubic,
                            width: 30,
                            height: heightFactor * 120, // max internal height
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isToday 
                                  ? [AppColors.primary, AppColors.primary.withOpacity(0.5)]
                                  : [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: isToday ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ] : [],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('E').format(date).toUpperCase().substring(0, 1),
                      style: GoogleFonts.inter(
                        color: isToday ? AppColors.primary : Colors.white24,
                        fontSize: 10,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
