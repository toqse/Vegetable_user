import 'package:ecom_app2/view/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Delivery extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  Delivery({required this.products});

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isEditable = false;
  bool _isFirstOrder = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('userDetails')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data();
          setState(() {
            _nameController.text = data?['name'] ?? '';
            _addressController.text = data?['address'] ?? '';
            _phoneController.text = data?['phone'] ?? '';
            _pinCodeController.text = data?['pinCode'] ?? '';
            _isFirstOrder = false; // Details exist, it's not the first order
          });
        }
      } catch (e) {
        print("Error fetching user details: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching user details: $e")),
        );
      }
    }
  }

  Future<void> saveDeliveryDetails(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final updatedProducts = widget.products.map((product) {
      return {
        'title': product['title'],
        'quantity': product['quantity'],
        'totalPrice': product['totalPrice'], // Use totalPrice field directly
        'imageUrl': product['imageUrl'] ?? 'https://via.placeholder.com/150',
      };
    }).toList();

    try {
      // Save order details
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'pinCode': _pinCodeController.text.trim(),
        'products': updatedProducts,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Save user details for future autofill
      await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(user.uid)
          .set({
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'pinCode': _pinCodeController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order placed successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error saving order details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error placing order: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Enter Delivery Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name is required'
                        : null,
                    readOnly: !_isFirstOrder && !_isEditable,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Address is required'
                        : null,
                    readOnly: !_isFirstOrder && !_isEditable,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Phone is required'
                        : null,
                    readOnly: !_isFirstOrder && !_isEditable,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _pinCodeController,
                    decoration: const InputDecoration(labelText: 'Pin Code'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Pin Code is required'
                        : null,
                    readOnly: !_isFirstOrder && !_isEditable,
                  ),
                  const SizedBox(height: 10),
                  if (!_isFirstOrder)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditable = !_isEditable;
                          });
                        },
                        child: Text(
                          _isEditable ? 'Save Changes' : 'Edit',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        saveDeliveryDetails(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return ListTile(
                  leading: Image.network(
                    product['imageUrl'] ?? '',
                    fit: BoxFit.cover,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 50),
                  ),
                  title: Text(product['title']),
                  subtitle: Text('Quantity: ${product['quantity']}'),
                  trailing: Text(
                      '₹${product['totalPrice']}'), // Display totalPrice directly
                );
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Gpay No : +91 9400563080',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 120),
            const Text(
              'Note: There is no cancellation after order.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
