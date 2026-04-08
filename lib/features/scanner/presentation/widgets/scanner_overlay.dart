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
        // Dark background with cutout
        ColorFiltered(
          colorFilter: ColorFilter.mode(
                Colors.black.withAlpha((0.5 * 255).toInt()),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: scanAreaSize,
                      height: scanAreaSize,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Scanning frame
            Align(
              alignment: Alignment.center,
              child: Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2000.ms, color: Colors.deepPurpleAccent.withAlpha((0.5 * 255).toInt())),
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
                      color: Colors.deepPurpleAccent.withAlpha((0.5 * 255).toInt()),
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
