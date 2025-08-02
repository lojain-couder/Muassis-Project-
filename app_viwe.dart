import 'package:flutter/material.dart';
import 'package:gg/main_navigation.dart';


class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'حسابي',
    theme: ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 238, 226, 203), // الخلفية الرئيسية
      colorScheme: const ColorScheme.light(
        surface: Colors.white,
      ),
    ),
    home: const MainNavigation(),

  );
}
}