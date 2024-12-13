import 'package:cuacaqu/screen/verivy.dart';
import 'package:flutter/material.dart';
import 'package:cuacaqu/themes/colors.dart';
import 'package:cuacaqu/screen/get_started.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imageHeight = size.height * 0.3;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                // Text Forget Password
                const Text(
                  "Forget Password",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                // App Name
                const Text(
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
                  'assets/images/Inputemail.png',
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 16),

                // Description
                const Text(
                  "Enter your registered email address. We'll send you a link to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                const SizedBox(height: 30),
                // Button Submit
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Verivy()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
                // Back to Getstarted
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GetStarted()),
                    );
                    ("Back to Get Started pressed");
                  },
                  child: Text(
                    "Back to Get Started",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
