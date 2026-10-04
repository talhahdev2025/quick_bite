import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_durations.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/splash/presentation/providers/provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _topCircleAnimation;
  late final Animation<Offset> _bottomCircleAnimation;
  late final Animation<double> _imageScaleAnimation;
  late final Animation<Offset> _buttonTranslateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic, // Smoother curve than linear
    );

    // Using relative fractional offsets for SlideTransition
    _topCircleAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.1, 0.1),
    ).animate(curvedAnimation);

    _bottomCircleAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, -0.1),
    ).animate(curvedAnimation);

    _imageScaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(curvedAnimation);

    _buttonTranslateAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(curvedAnimation);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onGetStartedPressed() async {
    await _controller.reverse();
    if (!mounted) return;
    await ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Top Decorative Circle
          Positioned(
            top: -100,
            right: -100,
            child: SlideTransition(
              position: _topCircleAnimation,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkPrimary,
                ),
              ),
            ),
          ),

          // Bottom Decorative Circle
          Positioned(
            bottom: -100,
            left: -150,
            child: SlideTransition(
              position: _bottomCircleAnimation,
              child: Container(
                width: 400,
                height: 400,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [AppColors.darkPrimary, AppColors.primary],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Main Content Area
          SafeArea(
            child: Padding(
              padding: AppInsets.hXxxl,
              child: Column(
                children: [
                  const Spacer(),

                  // Splash Image
                  ScaleTransition(
                    scale: _imageScaleAnimation,
                    child: Image.asset(
                      'assets/splash_img.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(),

                  // Action Button
                  SlideTransition(
                    position: _buttonTranslateAnimation,
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _onGetStartedPressed,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primary,
                          padding: AppInsets.button,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.large,
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
