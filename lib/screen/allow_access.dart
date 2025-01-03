// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cuacaqu/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cuacaqu/services/location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class AllowAccess extends StatefulWidget {
  const AllowAccess({super.key});

  @override
  State<AllowAccess> createState() => _AllowAccessState();
}

class _AllowAccessState extends State<AllowAccess> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imageHeight = size.height * 0.3;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "CuacaQu",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Image
                Image.asset(
                  'assets/images/Allowacc.png',
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Log in to return to the app. Register to enjoy exclusive features.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 50),

                // Login Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        // Ambil lokasi pengguna
                        Position position =
                            await LocationService().determinePosition();

                        if (!mounted) return; // Pastikan widget masih terpasang

                        // Mendapatkan nama lokasi dari koordinat
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                position.latitude, position.longitude);
                        Placemark place = placemarks[0]; // Ambil alamat pertama

                        String location =
                            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";

                        // Tampilkan dialog lokasi berhasil
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.white,
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColors.primary,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Lokasi Anda",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  color: AppColors.darkGrey.withOpacity(0.4),
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                              ],
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    location,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Latitude: ${position.latitude}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Longitude: ${position.longitude}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigasi ke halaman Home setelah mendapatkan lokasi
                                      Get.offAllNamed('/home');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                    ),
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(
                                        color: AppColors.lightGrey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;

                        // Tampilkan dialog jika terjadi error
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text("Error"),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Allow Access",
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // Privacy Policy
                const Text(
                  "By continuing, you agree to our Privacy Policy and Terms & Conditions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
