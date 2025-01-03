import 'package:cuacaqu/bindings/home_binding.dart';
import 'package:cuacaqu/bloc/weather_bloc.dart';
import 'package:cuacaqu/screen/allow_access.dart';
import 'package:cuacaqu/screen/get_started.dart';
import 'package:cuacaqu/screen/home.dart';
import 'package:cuacaqu/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Pastikan untuk mengimpor flutter_bloc

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CuacaQu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Route pertama aplikasi, menuju SplashScreen
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreen(), // Halaman SplashScreen
        ),
        GetPage(
          name: '/getStarted',
          page: () => GetStarted(), // Halaman GetStarted
        ),
        GetPage(
          name: '/allow_acc',
          page: () => AllowAccess(), // Halaman AllowAccess
        ),
        GetPage(
          name: '/home',
          page: () => BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(
                homeController:
                    Get.find()), // Mengambil HomeController dari Get.find()
            child: const HomePage(), // Halaman Home yang membutuhkan Bloc
          ),
          binding: HomeBinding(), // Mengikat controller ke halaman Home
        ),
        // Tambahkan halaman lain jika ada
      ],
    );
  }
}
