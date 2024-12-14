import 'package:ecom_app2/view/deliverd.dart';
import 'package:ecom_app2/view/readtodeliver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecom_app2/view/myorders.dart';
import 'package:ecom_app2/view/login_page/login_page.dart';
import 'package:ecom_app2/animations/slideleft.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../faq_and_about/about.dart';
import '../faq_and_about/faq.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String? _name;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userId = user.uid; // Get the logged-in user's UID

        // Fetch the user's profile from Firestore using the UID
        final doc = await FirebaseFirestore.instance
            .collection('userDetails') // Fetch from 'userDetails' collection
            .doc(userId) // Use UID as the document ID
            .get();

        if (doc.exists) {
          setState(() {
            _name = doc.data()?['name'] ?? 'Unknown User'; // Fetch `name` field
          });
        } else {
          setState(() {
            _name = 'No Profile Found';
          });
          print("No document found for user ID: $userId");
        }
      } else {
        print("No user logged in.");
        _navigateToLogin(); // Navigate to the login page
      }
    } catch (e) {
      print("Error fetching profile data: $e");
      _showSnackBar('Failed to fetch profile data.');
    }
  }

// Helper function to show a snack bar with an error message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

// Helper function to navigate to the login page
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Phone()), // Replace with your login page
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Account',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildHeader(width),
          _buildDivider(),
          _buildAccountOption(
            icon: FontAwesomeIcons.boxesPacking,
            title: 'Processing Orders',
            onTap: () =>
                Navigator.push(context, SlideLeftRoute(page: MyOrders())),
          ),
          _buildDivider(),
          _buildAccountOption(
            icon: FontAwesomeIcons.truckFast,
            title: 'Ready for Delivery',
            onTap: () =>
                Navigator.push(context, SlideLeftRoute(page: Readtodeliver())),
          ),
          _buildDivider(),
          _buildAccountOption(
            icon: FontAwesomeIcons.history,
            title: 'Delivered History',
            onTap: () =>
                Navigator.push(context, SlideLeftRoute(page: Delivered())),
          ),
          _buildDivider(),
          _buildAccountOption(
            icon: FontAwesomeIcons.questionCircle,
            title: 'FAQ',
            onTap: () =>
                Navigator.push(context, SlideLeftRoute(page: FaqPage())),
          ),
          _buildDivider(),
          _buildAccountOption(
            icon: FontAwesomeIcons.info,
            title: 'About Us',
            onTap: () =>
                Navigator.push(context, SlideLeftRoute(page: AboutApp())),
          ),
          _buildDivider(),
          _buildAccountOption(
            icon: FontAwesomeIcons.signOutAlt,
            title: 'Log Out',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Log Out"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // Log out from Firebase
                            await FirebaseAuth.instance.signOut();

                            // Clear any locally stored user session data
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.setBool('islogged', false);

                            // Navigate to the login page
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Phone()),
                              (route) => false,
                            );
                          } catch (e) {
                            print("Error during logout: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to log out. Please try again.')),
                            );
                          }
                        },
                        child: Text("Yes"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Container(
      width: width,
      height: 100.0, // Reduced height
      color: Colors.green.shade50, // Light green background color
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white, // White background for the name box
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Text(
            _name ?? 'Loading...', // Display user's name or 'Loading...'
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Dark text color
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountOption(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 30.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 25),
            Text(
              title,
              style: const TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(right: 30.0, left: 70.0),
      child: Divider(height: 1.0),
    );
  }
}
