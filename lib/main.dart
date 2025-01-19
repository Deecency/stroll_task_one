import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroll/features/splash/splash.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        ensureScreenSize: true,
        child: const SplashScreen(),
        builder: (context, child) {
          return MaterialApp(
            title: 'Scroll',
            debugShowCheckedModeBanner: false,
            home: child,
          );
        },
      );
    });
  }
}

final talker = TalkerFlutter.init(
  settings: TalkerSettings(),
  logger: TalkerLogger(
    output: debugPrint,
    settings: TalkerLoggerSettings(
      enableColors: !Platform.isIOS,
    ),
  ),
);
