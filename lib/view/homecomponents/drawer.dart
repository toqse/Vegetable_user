import 'package:ecom_app2/view/cart.dart';
import 'package:ecom_app2/view/myaccount/account.dart';
import 'package:ecom_app2/view/myorders.dart';
import 'package:ecom_app2/view/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../categories/fruit.dart';
import '../../categories/poultry.dart';
import '../../categories/spices.dart';
import '../../categories/veggies.dart';
import '../faq_and_about/about.dart';
import '../faq_and_about/faq.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _helplineNumber1 = 'Not Available';
  String _helplineNumber2 = 'Not Available';

  @override
  void initState() {
    super.initState();
    _fetchHelplineNumbers();
  }

  Future<void> _fetchHelplineNumbers() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('helpline')
          .doc('numbers')
          .get();

      if (doc.exists) {
        print("Document Data: ${doc.data()}"); // Debug print
        setState(() {
          _helplineNumber1 = doc.data()?['number1'] ?? 'Not Available';
          _helplineNumber2 = doc.data()?['number2'] ?? 'Not Available';
        });
      } else {
        print("Document does not exist");
        setState(() {
          _helplineNumber1 = 'Not Available';
          _helplineNumber2 = 'Not Available';
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _helplineNumber1 = 'Error fetching number';
        _helplineNumber2 = 'Error fetching number';
      });
    }
  }

  Future<void> _makeCall(BuildContext context, String number) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Call Helpline",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Do you want to call $number?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                final Uri callUri = Uri(scheme: 'tel', path: number);
                if (await canLaunchUrl(callUri)) {
                  await launchUrl(callUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $number')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes", style: TextStyle(color: Colors.green)),
              onPressed: () {
                // Perform logout action here
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white, // Drawer background color
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Header with logo
              Container(
                height: 160.0,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: SizedBox(
                    height: 55.0,
                    width: 280.0,
                    child: Image.asset(
                      'assets/easy.png',
                      // Replace with your logo or image asset
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    buildMenuItem(
                      icon: Icons.account_balance_wallet,
                      text: 'My Orders',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyOrders()),
                        );
                      },
                    ),
                    buildMenuItem(
                      icon: Icons.shopping_cart,
                      text: 'My Cart',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartPage()),
                        );
                      },
                    ),
                    buildMenuItem(
                      icon: Icons.favorite,
                      text: 'My Wishlist',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WishlistPage()),
                        );
                      },
                    ),
                    buildMenuItem(
                      icon: Icons.person,
                      text: 'My Account',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyAccount()),
                        );
                      },
                    ),
                    const Divider(color: Colors.grey), // Divider
                    buildMenuItem(
                      icon: Icons.food_bank,
                      text: 'Cut Veggies',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VeggiesPage(title: 'Vegetables')),
                        );
                      },
                    ),
                    buildMenuItem(
                      icon: Icons.apple,
                      text: 'Fruits',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Fruits(title: 'Fruits')),
                        );
                      },
                    ),
                    buildMenuItem(
                      icon: Icons.local_fire_department,
                      text: 'Spices',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Spices(title: 'Spices')),
                        );
                      },
                    ),
                    buildMenuItem(
                      icon: Icons.set_meal,
                      text: 'Poultry',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Poultry(title: 'Poultry')),
                        );
                      },
                    ),
                    const Divider(color: Colors.grey), // Divider
                    buildMenuItem(
                      icon: Icons.help,
                      text: 'FAQ',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FaqPage()),
                        );
                      },
                    ),
                    buildMenuItem(
                      icon: Icons.info,
                      text: 'About Us',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutApp()),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Helpline Numbers:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => _makeCall(context, _helplineNumber1),
                            child: Text(
                              _helplineNumber1,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => _makeCall(context, _helplineNumber2),
                            child: Text(
                              _helplineNumber2,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
