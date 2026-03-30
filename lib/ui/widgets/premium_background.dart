import 'package:flutter/material.dart';
import 'package:focus/core/theme.dart';

class PremiumBackground extends StatelessWidget {
  final Widget child;
  const PremiumBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.background),
        CustomPaint(
          size: Size.infinite,
          painter: CurvePainter(),
        ),
        child,
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Subtle curves as seen in the mockup
    final path1 = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.1,
        size.width, size.height * 0.3
      );

    final path2 = Path()
      ..moveTo(-50, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.4, size.height * 0.5,
        size.width + 50, size.height * 0.8
      );

    final path3 = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.4),
        width: size.width * 0.6,
        height: size.width * 0.6,
      ));

    // Drawing with low opacity glowing lines
    paint.color = AppColors.primary.withOpacity(0.05);
    canvas.drawPath(path1, paint);
    
    paint.color = AppColors.accent.withOpacity(0.03);
    canvas.drawPath(path2, paint);
    
    paint.color = AppColors.primary.withOpacity(0.02);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
