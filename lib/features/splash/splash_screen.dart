import 'dart:async';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wave/wave.dart';

class GeneratedWave extends StatelessWidget {
  const GeneratedWave({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 200,
      child: WaveWidget(
        config: CustomConfig(
          gradients: const [
            [Color.fromARGB(17, 228, 88, 130), AppColors.primaryLight],

            [Color(0x1EE45882), AppColors.primaryLight],
          ],
          durations: const [10588, 9059],
          heightPercentages: const [0.82, 0.86],
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),

        size: const Size(double.infinity, double.infinity),
        waveAmplitude: 28.0,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final duration = Duration(seconds: 4);

    _timer = Timer(duration, _onSplashTimeout);
  }

  void _onSplashTimeout() {
    if (_isNavigating) return;
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (_isNavigating) return;
    _isNavigating = true;
    _timer?.cancel();

    context.pushAndRemoveUntil(OnBoardingScreen());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splash_bg.png', fit: BoxFit.cover),
          Align(
            alignment: Alignment(0, -.5),
            child: Column(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                Image.asset(
                  'assets/images/splash_illustration.png',
                ).animate().fadeIn(duration: 400.ms),
                48.heightBox,
                Image.asset('assets/images/splash_logo.png', height: 78)
                    .animate(onPlay: (controller) => controller.repeat())
                    .scaleXY(
                      begin: .7,
                      end: 1,
                      duration: 1000.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scaleXY(
                      begin: 1,
                      end: .7,
                      duration: 1000.ms,
                      curve: Curves.easeInOut,
                    ),
                24.heightBox,
                RichText(
                  text: TextSpan(
                    text: AppStrings.fitness,
                    style: context.displayMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${AppStrings.plus}',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ).animate().fade(),
                Text(
                  AppStrings.moveBetterFeelStronger,
                  style: context.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(),
                80.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),

                      child:
                          Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryGradientStart,
                                ),
                              )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .scaleXY(
                                begin: 0.5,
                                end: 1.2,
                                duration: 400.ms,
                                delay: (index * 150).ms,
                                curve: Curves.easeInOut,
                              )
                              .then()
                              .scaleXY(
                                begin: 1.2,
                                end: 0.5,
                                duration: 400.ms,
                                curve: Curves.easeInOut,
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(alignment: Alignment(0, .7), child: GeneratedWave()),
        ],
      ),
    );
  }
}
