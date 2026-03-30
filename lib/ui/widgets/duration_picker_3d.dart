import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:focus/core/theme.dart';

class DurationPicker3D extends StatefulWidget {
  final ValueChanged<int> onDurationChanged;
  final int initialDuration;

  const DurationPicker3D({
    super.key,
    required this.onDurationChanged,
    this.initialDuration = 60,
  });

  @override
  State<DurationPicker3D> createState() => _DurationPicker3DState();
}

class _DurationPicker3DState extends State<DurationPicker3D> {
  late PageController _pageController;
  final List<int> _durations = List.generate(12, (index) => (index + 1) * 15);
  int _selectedIndex = 3; // Default to 60 (4th item if starting from 15)

  @override
  void initState() {
    super.initState();
    _selectedIndex = _durations.indexOf(widget.initialDuration);
    if (_selectedIndex == -1) _selectedIndex = 3;
    _pageController = PageController(
      viewportFraction: 0.3,
      initialPage: _selectedIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
          widget.onDurationChanged(_durations[index]);
        },
        itemCount: _durations.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
              }

              final isSelected = index == _selectedIndex;

              return Center(
                child: Transform.scale(
                  scale: Curves.easeOut.transform(value),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateY((index - (_pageController.position.haveDimensions ? _pageController.page! : _selectedIndex.toDouble())) * 0.2),
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: isSelected
                          ? BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            )
                          : BoxDecoration(
                              color: AppColors.glassBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                      child: Center(
                        child: Text(
                          '${_durations[index]}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
