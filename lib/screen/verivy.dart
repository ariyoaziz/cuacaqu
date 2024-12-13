import 'package:cuacaqu/screen/reset_password.dart';
import 'package:cuacaqu/themes/colors.dart';
import 'package:flutter/material.dart';

class Verivy extends StatefulWidget {
  const Verivy({super.key});

  @override
  State<Verivy> createState() => _VerivyState();
}

class _VerivyState extends State<Verivy> {
  // TextEditingController untuk setiap TextField
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  // Fungsi untuk membuat TextField OTP
  Widget _otpTextField(BuildContext context, TextEditingController controller) {
    return SizedBox(
      width: 50, // Lebar input
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // Hanya 1 karakter
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imageHeight = size.height * 0.3;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.1),
                const Text(
                  "Verify Your OTP",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 16),

                // Image
                Image.asset(
                  'assets/images/verivy.png',
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 16),

                // Description
                const Text(
                  "Enter the 4-digit code we sent to your email to verify your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),

                const SizedBox(height: 30),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _otpTextField(context, controller1),
                    const SizedBox(width: 8),
                    _otpTextField(context, controller2),
                    const SizedBox(width: 8),
                    _otpTextField(context, controller3),
                    const SizedBox(width: 8),
                    _otpTextField(context, controller4),
                  ],
                ),

                const SizedBox(height: 30),

                // Verify Button
                SizedBox(
                  width: size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      // // Gabungkan semua input OTP
                      // String otp = controller1.text +
                      //     controller2.text +
                      //     controller3.text +
                      //     controller4.text;

                      // // Validasi OTP
                      // if (otp.length == 4) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('OTP: $otp')),
                      //   );
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text('Please enter the complete OTP!'),
                      //     ),
                      //   );
                      // }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPassword()),
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
                      "Verify",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
