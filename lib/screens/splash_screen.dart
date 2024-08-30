import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kkh_events/screens/main_main.dart';
import 'dart:async';

import 'package:kkh_events/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainMainScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: KKHTextPainter(animation: _animation),
          child: SizedBox(
            width: 200,
            height: 100,
          ),
        ),
      ),
    );
  }
}

class KKHTextPainter extends CustomPainter {
  final Animation<double> animation;
  KKHTextPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final path = Path();

    // K letter
    path.moveTo(20, 80);
    path.lineTo(20, 20);
    path.moveTo(20, 50);
    path.lineTo(50, 20);
    path.moveTo(20, 50);
    path.lineTo(50, 80);

    // Second K letter
    path.moveTo(80, 80);
    path.lineTo(80, 20);
    path.moveTo(80, 50);
    path.lineTo(110, 20);
    path.moveTo(80, 50);
    path.lineTo(110, 80);

    // H letter
    path.moveTo(140, 80);
    path.lineTo(140, 20);
    path.moveTo(140, 50);
    path.lineTo(170, 50);
    path.moveTo(170, 80);
    path.lineTo(170, 20);

    final drawPath = createAnimatedPath(path, animation.value);

    canvas.drawPath(drawPath, paint);
  }

  Path createAnimatedPath(Path originalPath, double animationPercent) {
    final totalLength = originalPath.computeMetrics().fold<double>(
        0.0, (double prev, PathMetric metric) => prev + metric.length);

    double currentLength = 0.0;

    final path = Path();

    for (PathMetric metric in originalPath.computeMetrics()) {
      final animationLength = metric.length * animationPercent;
      final newLength = currentLength + animationLength;

      if (newLength < totalLength) {
        path.addPath(metric.extractPath(0.0, animationLength), Offset.zero);
      } else {
        path.addPath(metric.extractPath(0.0, metric.length), Offset.zero);
      }

      currentLength += metric.length;
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
