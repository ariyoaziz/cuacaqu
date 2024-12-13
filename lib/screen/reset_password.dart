import 'package:cuacaqu/screen/login.dart';
import 'package:cuacaqu/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isPasswordVisible = false;

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
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                  'assets/images/restpassword.png',
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
                const SizedBox(height: 30),

                // TextField Password
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'New Password',
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
                        Icons.lock,
                        color: AppColors.primary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _isPasswordVisible = !_isPasswordVisible;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // Cobnfrim Password
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm  Password',
                      hintText: 'Confirm Password',
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
                        Icons.lock,
                        color: AppColors.primary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _isPasswordVisible = !_isPasswordVisible;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Login Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
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
                      "Login",
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // Sign Up
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                    ),
                    children: [
                      const TextSpan(text: "Already reset your password? "),
                      TextSpan(
                        text: ' Login',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
