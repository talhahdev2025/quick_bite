import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_durations.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _topCircleAnimation;
  late Animation<Offset> _bottomCircleAnimation;
  late Animation<double> _imageScaleAnimation;
  late Animation<Offset> _buttonTranslateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
    );

    _topCircleAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-30, 30),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _bottomCircleAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(30, -30),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _imageScaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _buttonTranslateAnimation = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    //controller
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Stack(
            children: [
              //top container
              Positioned(
                top: -100,
                right: -200,
                child: Transform.translate(
                  offset: _topCircleAnimation.value,
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
              //bottom container
              Positioned(
                bottom: 100,
                left: -300,
                child: Transform.translate(
                  offset: _bottomCircleAnimation.value,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: [AppColors.darkPrimary, AppColors.primary],
                        stops: [0.5, 1],
                      ),
                    ),
                  ),
                ),
              ),
              //
              Positioned(
                bottom: 50,
                right: 0,
                left: 0,
                child: SizedBox(
                  width: double.infinity,
                  height: 450,
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _imageScaleAnimation,
                        child: Image.asset('assets/splash_img.png'),
                      ),
                      const Spacer(),
                      Transform.translate(
                        offset: _buttonTranslateAnimation.value,
                        child: Container(
                          margin: AppInsets.hXxxl,
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () async {
                              final router = GoRouter.of(context);
                              await _controller.reverse();
                              if (!mounted) return;
                              router.go(AppRoutes.loginPath);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.primary,
                              padding: AppInsets.button,
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppRadius.large,
                              ),
                            ),
                            child: Padding(
                              padding: AppInsets.button,
                              child: Text(
                                'Get Started',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
