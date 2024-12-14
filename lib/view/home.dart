import 'package:flutter/material.dart';
import 'package:ecom_app2/view/cart.dart';
import 'package:ecom_app2/view/homescreen/homescreen.dart';
import 'package:ecom_app2/view/myaccount/account.dart';
import 'package:ecom_app2/view/search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    SearchPage(),
    CartPage(),
    MyAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page dynamically
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index; // Update selected index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
