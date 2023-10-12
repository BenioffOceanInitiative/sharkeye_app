import 'package:flutter/material.dart';
import 'package:sharkeye/home.dart';

void main() {
  runApp(const MyApp());
}

// #2596BE
// 0xFF2596BE
//rgb(37, 150, 190)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2596BE),
        ),
        useMaterial3: true,
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
