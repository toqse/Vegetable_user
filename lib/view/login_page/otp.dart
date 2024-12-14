import 'package:ecom_app2/view/home.dart';
import 'package:ecom_app2/view/homescreen/homescreen.dart';
import 'package:ecom_app2/view/login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set AppBar color to green
        title: const Text(
          'Verify OTP',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        centerTitle: true, // Center the title text
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // Set background color to white
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 350,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      _buildOtpField(context, otp1),
                      _buildOtpField(context, otp2),
                      _buildOtpField(context, otp3),
                      _buildOtpField(context, otp4),
                      _buildOtpField(context, otp5),
                      _buildOtpField(context, otp6),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                      ),
                      Text("Didn't Get OTP? "),
                      TextButton(
                        onPressed: () {
                          // Add your resend OTP logic here
                        },
                        child: Text("Resend OTP"),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Create a credential using the verificationId and the OTP entered by the user
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId:
                            Phone.verify, // Replace with your verification ID
                        smsCode: otp1.text +
                            otp2.text +
                            otp3.text +
                            otp4.text +
                            otp5.text +
                            otp6.text,
                      );

                      // Authenticate with Firebase using the credential
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);

                      // Save login state in shared preferences
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool(
                          'isLoggedIn', true); // Save login state

                      // Navigate to Home screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    } catch (e) {
                      print(e);
                      // Show an error message to the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.yellow, // Set button color to yellow
                    foregroundColor:
                        Colors.black, // Set text color for contrast
                  ),
                  child: const Text("DONE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build OTP input fields
  Widget _buildOtpField(
      BuildContext context, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 58,
        width: 40,
        child: TextFormField(
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          controller: controller,
          style: Theme.of(context).textTheme.headlineMedium,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }
}
