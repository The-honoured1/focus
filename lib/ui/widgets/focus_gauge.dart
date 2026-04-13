import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import 'dart:ui';
import 'dart:math' as math;

class FocusGauge extends StatelessWidget {
  final int currentMinutes;
  final int goalMinutes;
  final double size;
  final bool showInfo;

  const FocusGauge({
    super.key,
    required this.currentMinutes,
    required this.goalMinutes,
    this.size = 200,
    this.showInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentMinutes / goalMinutes).clamp(0.0, 1.0);
    final int remaining = math.max(0, goalMinutes - currentMinutes);

    return Container(
      padding: showInfo ? const EdgeInsets.symmetric(vertical: 20) : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glow
              Container(
                width: size + 20,
                height: size + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.05),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              
              // Progress Ring
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: showInfo ? 4 : 3,
                  color: AppColors.primary,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  strokeCap: StrokeCap.round,
                ),
              ),
              
              // Internal Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showInfo)
                    Text(
                      'FOCUS TODAY',
                      style: GoogleFonts.inter(
                        color: Colors.white24,
                        fontSize: size * 0.05,
                        letterSpacing: 2,
                      ),
                    ),
                  if (showInfo) const SizedBox(height: 8),
                  Text(
                    '$currentMinutes',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: size * 0.24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'MINS',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: size * 0.06,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showInfo) ...[
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoTile('Remaining', '$remaining mins'),
                Container(width: 1, height: 20, color: Colors.white10, margin: const EdgeInsets.symmetric(horizontal: 24)),
                _infoTile('Goal', '$goalMinutes mins'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(color: Colors.white24, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
