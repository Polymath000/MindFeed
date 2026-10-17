import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class HomeBreathingBackground extends StatefulWidget {
  const HomeBreathingBackground({super.key});

  @override
  State<HomeBreathingBackground> createState() =>
      _HomeBreathingBackgroundState();
}

class _HomeBreathingBackgroundState extends State<HomeBreathingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathingController;
  late final Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);
    _breathingAnimation = CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (context, child) {
        final t = _breathingAnimation.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.inkDarker,
                    AppColors.inkDarkest,
                    AppColors.almostBlack,
                  ],
                ),
              ),
            ),
            Positioned(
              top: -140 + (t * 30),
              left: -60 + (t * 25),
              width: 440 + (t * 40),
              height: 440 + (t * 40),
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color.fromARGB(
                          (65 + (t * 40)).round(),
                          255,
                          222,
                          148,
                        ),
                        Color.fromARGB(
                          (26 + (t * 20)).round(),
                          242,
                          185,
                          110,
                        ),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 150 - (t * 25),
              right: -110 - (t * 20),
              width: 380 + (t * 30),
              height: 380 + (t * 30),
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color.fromARGB(
                          (50 + ((1.0 - t) * 35)).round(),
                          230,
                          140,
                          120,
                        ),
                        Color.fromARGB(
                          (20 + ((1.0 - t) * 18)).round(),
                          190,
                          100,
                          85,
                        ),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80 + (t * 20),
              left: -40 + (t * 20),
              width: 320 + (t * 25),
              height: 320 + (t * 25),
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color.fromARGB(
                          (38 + (t * 25)).round(),
                          165,
                          190,
                          245,
                        ),
                        Color.fromARGB(
                          (14 + (t * 12)).round(),
                          125,
                          150,
                          205,
                        ),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.0, -0.35 + (t * 0.15)),
                      radius: 1.15 + (t * 0.25),
                      colors: [
                        Color.fromARGB(
                          (22 + (t * 22)).round(),
                          255,
                          240,
                          205,
                        ),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
