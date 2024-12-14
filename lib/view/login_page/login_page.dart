import 'dart:developer';

import 'package:ecom_app2/view/login_page/otp.dart';
import 'package:ecom_app2/view/home.dart'; // Ensure you have this file
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phone extends StatefulWidget {
  static String verify = ''; // Static variable to store verification ID

  const Phone({Key? key}) : super(key: key);

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController phone = TextEditingController();
  TextEditingController countrycode =
      TextEditingController(text: "+91"); // Default country code for India

  // Function to initiate phone authentication
  Future<void> authFunction(BuildContext context) async {
    final phoneNumber = "${countrycode.text}${phone.text.trim()}";

    // Validate phone number input
    if (phone.text.isEmpty || phone.text.length < 10) {
      _showError("Please enter a valid phone number.");
      return;
    }

    try {
      // Firebase phone number verification
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            // Automatically sign in if verification is successful
            UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);

            if (userCredential.user != null) {
              // Save login state in SharedPreferences
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setBool('isLoggedIn', true);

              // Navigate to the Home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            }
          } catch (e) {
            _showError("Automatic sign-in failed: $e");
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          // Handle verification failure
          if (error.code == 'invalid-phone-number') {
            _showError("The provided phone number is not valid.");
          } else {
            _showError("Verification failed: ${error.message}");
            log(error.message.toString());
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Save the verification ID for manual OTP entry
          Phone.verify = verificationId;

          // Navigate to the OTP verification page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OTP()),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout callback
          Phone.verify = verificationId;
          log("Auto-retrieval timeout for verification ID: $verificationId");
        },
      );
    } catch (e) {
      // Handle any errors during phone verification setup
      _showError("An error occurred: $e");
    }
  }

  // Helper function to show error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Green app bar
        automaticallyImplyLeading: false, // Removes the back button
        title: Center(
          child: Image.asset(
            'assets/easy.png', // Path to your logo
            height: 40.0, // Adjust the height as needed
          ),
        ),
        elevation: 0, // Optional: Removes shadow for a cleaner look
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Phone Number",
              style: TextStyle(
                  color: Colors.black, // Change text color to black
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: countrycode,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "+91",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  flex: 5,
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Enter Phone Number",
                      iconColor: Colors.black,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                authFunction(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set green background
              ),
              child: const Text(
                "Get OTP",
                style: TextStyle(color: Colors.white),
              ),
            ),
            // const SizedBox(height: 20.0),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to the SignupPage
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const SignUpPage()),
            //     );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.yellow, // Set yellow background
            //   ),
            //   child: const Text(
            //     "Create a New Account",
            //     style: TextStyle(
            //       color: Colors.black, // Set text color to contrast
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
