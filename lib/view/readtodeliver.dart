import 'package:ecom_app2/view/products/productdetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting

class Readtodeliver extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<Readtodeliver> {
  final String userId =
      FirebaseAuth.instance.currentUser!.uid; // Get logged-in userId

  Widget _checkStatus(String status) {
    if (status == 'Pending') {
      return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
    } else if (status == 'Accepted') {
      return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
    } else if (status == 'Delivered') {
      return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
    } else {
      return Container();
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  int calculateTotalQuantity(List<dynamic> products) {
    int totalQuantity = 0;
    for (var product in products) {
      totalQuantity +=
          (product['quantity'] ?? 0) as int; // Explicitly cast to int
    }
    return totalQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders Ready For Delivery',
          style: const TextStyle(fontSize: 14.0, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('acceptedorders')
            .where('userId', isEqualTo: userId) // Filter orders by userId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final String status = order['status'] ?? 'Pending';
              final List<dynamic> products = order['products'] ?? [];
              final Timestamp? timestamp = order['timestamp'];

              final int totalQuantity = calculateTotalQuantity(products);

              // Fetch `totalPrice` from Firebase collection
              final String totalPriceString =
                  order['totalPrice'] ?? '0'; // Get total price as string
              final double totalPrice =
                  double.tryParse(totalPriceString) ?? 0.0; // Convert to double

              return GestureDetector(
                onTap: () {
                  if (products.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          products: [
                            {
                              'title': products[0]['title'] ?? 'No Title',
                              'quantity': products[0]['quantity'] ?? 1,
                              'offerPrice': products[0]['offerPrice'] ?? 0,
                              'imageUrl': products[0]['imageUrl'] ?? '',
                            }
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 200.0,
                  child: Card(
                    elevation: 5.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 10,
                          right: 10,
                          child: _checkStatus(status),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Product Image
                              Container(
                                width: 120.0,
                                height: 160.0,
                                child: Image.network(
                                  products.isNotEmpty &&
                                          products[0]['imageUrl'] != null
                                      ? products[0]['imageUrl']
                                      : 'https://via.placeholder.com/120',
                                  // Placeholder image URL
                                  fit: BoxFit.fitHeight,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image_not_supported,
                                        size: 50);
                                  },
                                ),
                              ),
                              SizedBox(width: 10.0),

                              // Order Information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      products.isNotEmpty
                                          ? products[0]['title'] ?? 'No Title'
                                          : 'No Title',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      '₹${totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: const Color.fromARGB(
                                            255, 66, 64, 64),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    if (timestamp != null)
                                      Text(
                                        'Order Accepted Date and Time: ${formatTimestamp(timestamp)}',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 66, 64, 64),
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Total Quantity: ',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 66, 64, 64),
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          '$totalQuantity',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 66, 64, 64),
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
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
            },
          );
        },
      ),
    );
  }
}
