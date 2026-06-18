import 'dart:async';
import 'package:background_location_tracker/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showSubtext = false;

  @override
  void initState() {
    super.initState();
    _runInitializationPipeline();
  }

  Future<void> _runInitializationPipeline() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _showSubtext = true);
    }

    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const BaseBottomNavigationPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),

      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFF1D61FF)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.white.withAlpha(10),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: AnimatedOpacity(
                          opacity: value.clamp(0.0, 1.0),
                          duration: const Duration(milliseconds: 400),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(38),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.share_location_rounded,
                        color: Color(0xFF1D61FF),
                        size: 56,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'TRACKFLOW',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4.0,
                    ),
                  ),

                  AnimatedOpacity(
                    opacity: _showSubtext ? 0.75 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    child: const Text(
                      'Enterprise Telemetry Engine',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFE0E7FF),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                bottom: 60,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Initializing background subsystems...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withAlpha(128),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
