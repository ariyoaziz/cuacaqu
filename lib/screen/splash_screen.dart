import 'package:flutter/material.dart';
import 'package:cuacaqu/screen/get_started.dart';
import 'dart:async'; // Import untuk Future.delayed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool visible = false;

  @override
  void initState() {
    super.initState();

    // Delay untuk animasi fade-in logo
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        visible = true;
      });
    });

    // Menunggu 3 detik sebelum pindah ke halaman Get Started
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const GetStarted(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = 0.0;
              const end = 1.0;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return FadeTransition(
                opacity: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar untuk membuat layout responsif
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.5; // Ukuran logo 50% dari lebar layar

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration:
              const Duration(milliseconds: 800), // Perpanjang durasi animasi
          child: AnimatedScale(
            scale: visible ? 1.2 : 0.8, // Efek pembesaran logo
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut, // Curve animasi yang halus
            child: AnimatedSlide(
              offset: visible
                  ? Offset(0, 0)
                  : Offset(0, -0.2), // Efek slide dari atas
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: Image.asset(
                'assets/images/Logo.png',
                width: logoSize,
                height: logoSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
