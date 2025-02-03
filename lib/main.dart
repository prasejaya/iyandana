import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Pastikan import splash screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Splash Screen sebagai halaman awal
    );
  }
}
