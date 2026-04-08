import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.7;

    return Stack(
      children: [
        // Semi-transparent background with cutout
        CustomPaint(
          size: size,
          painter: ScannerOverlayPainter(
            scanAreaSize: scanAreaSize,
            borderRadius: 24,
          ),
        ),
        // Scanning frame (Border)
        Align(
          alignment: Alignment.center,
          child: Container(
            width: scanAreaSize,
            height: scanAreaSize,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withAlpha(150), width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: Colors.deepPurpleAccent.withAlpha(100)),
        ),
        // Pulsing scanning line
        Align(
          alignment: Alignment.center,
          child: Container(
            width: scanAreaSize - 20,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withAlpha(128),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -scanAreaSize / 2 + 20,
                end: scanAreaSize / 2 - 20,
                duration: 1500.ms,
                curve: Curves.easeInOut,
              ),
        ),
      ],
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final double borderRadius;

  ScannerOverlayPainter({
    required this.scanAreaSize,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: scanAreaSize,
            height: scanAreaSize,
          ),
          Radius.circular(borderRadius),
        ),
      );

    final path = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final paint = Paint()
      ..color = Colors.black.withAlpha(160) // Semi-transparent black
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
