import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // Untuk status bar
import 'package:iyandana/login_screen.dart';  // Ganti dengan rute login yang sesuai

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginScreen();
  }

  // Fungsi untuk navigasi ke login screen setelah splash screen
  _navigateToLoginScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Splash screen tampil selama 3 detik
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Ganti LoginScreen dengan nama file yang sesuai
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengatur status bar menjadi transparan
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Status bar transparan
    ));

    return Scaffold(
      backgroundColor: Colors.blue, // Ganti warna sesuai desain
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo atau gambar splash screen
            Image.asset('assets/images/logo.png', width: 150), // Ganti dengan path logo Anda
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white), // Indikator loading (opsional)
          ],
        ),
      ),
    );
  }
}
