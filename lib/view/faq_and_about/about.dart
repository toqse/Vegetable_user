import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Easy Cooking',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Welcome to Easy Cooking, your trusted partner for fresh, high-quality ingredients delivered right to your doorstep. Founded with a mission to simplify home cooking, we provide a seamless shopping experience for vegetables, fruits, spices, and poultry, ensuring every family has access to the freshest and finest products.',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'At Easy Cooking, we believe that great meals start with great ingredients. That’s why we source directly from local farmers, trusted vendors, and hygienic suppliers to bring you only the best. Whether you’re planning a quick weekday dinner or a festive feast, we’ve got everything you need to make your cooking experience enjoyable and stress-free.',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Thanks for installing our app!',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                const Divider(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
