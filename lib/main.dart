import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black, titleTextStyle: TextStyle(color: Colors.white, fontSize: 24)),
          useMaterial3: true,
        ),
        home: const HomePage());
  }
}
