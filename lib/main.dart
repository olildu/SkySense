import 'package:flutter/material.dart';
import 'package:weather_app/pages/mobileUI/home_page.dart';
import 'package:weather_app/responsive/responsive.dart';
import 'package:weather_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode,
      home: ResponsiveLayout(
        mobileBody: HomePageMobile(),
      ),
    );
  }
}