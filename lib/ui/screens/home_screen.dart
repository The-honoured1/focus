import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../features/focus/focus_provider.dart';
import '../../features/focus/session_history_provider.dart';
import '../../features/streak/streak_provider.dart';
import 'session_screen.dart';
import 'stats_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../widgets/premium_background.dart';
import 'create_focus_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PremiumBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=2070&auto=format&fit=crop'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_rounded, size: 16, color: Colors.black),
                    ),
                  ],
                ).animate().fadeIn().slideX(begin: -0.2),
                const SizedBox(height: 40),
                Text(
                  'Good morning,',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Theresa',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Tip Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You focus best in the mornings',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      Text(
                        'Plan better with Aura',
                        style: GoogleFonts.inter(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                
                const SizedBox(height: 32),
                
                // Focus Grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildFocusCard(context, '45', 'Certification preparation at ne..'),
                      _buildFocusCard(context, '30', 'Read Atomic Habits.'),
                      _buildFocusCard(context, '60', 'UI Design Session', isLarge: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateFocusScreen()),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        label: Row(
          children: [
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 8),
            Text('New focus', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ],
        ),
      ).animate().scale(delay: 600.ms),
    );
  }

  Widget _buildFocusCard(BuildContext context, String value, String title, {bool isLarge = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 48,
                  height: 1,
                  color: isLarge ? AppColors.primary : Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.north_east_rounded, size: 16, color: Colors.white),
              ),
            ],
          ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale();
  }
}
