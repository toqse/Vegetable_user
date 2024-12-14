import 'package:ecom_app2/view/home.dart';
import 'package:ecom_app2/view/products/productdetails.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final String userId =
      FirebaseAuth.instance.currentUser!.uid; // Current user ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wishlist')
            .where('userId', isEqualTo: userId) // Filter by userId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading wishlist"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    FontAwesomeIcons.heartCrack,
                    color: Colors.grey,
                    size: 60.0,
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'No Items in Wishlist',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Go To Home',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ));
                    },
                  ),
                ],
              ),
            );
          }

          final wishlistItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistItems[index].data() as Map<String, dynamic>;
              final docId = wishlistItems[index].id;

              return GestureDetector(
                onTap: () {
                  // Navigate to ProductDetails page when the card is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        products: [
                          {
                            'productId': docId,
                            'title': item['title'],
                            'imageUrl': item['imageUrl'],
                            'offerPrice': item['offerPrice'],
                            'originalPrice': item['originalPrice'],
                          }
                        ],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    height: 190.0,
                    child: Card(
                      elevation: 1.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 130.0,
                                height: 160.0,
                                child: Image.network(
                                  item['imageUrl'],
                                  fit: BoxFit.fitHeight,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    item['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 7.0),
                                  Text(
                                    '₹${item['offerPrice'] ?? '0'}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Add to cart logic
                                          final cartSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection('cart')
                                                  .where('userId',
                                                      isEqualTo: userId)
                                                  .where('title',
                                                      isEqualTo: item['title'])
                                                  .get();

                                          if (cartSnapshot.docs.isEmpty) {
                                            await FirebaseFirestore.instance
                                                .collection('cart')
                                                .add({
                                              'userId': userId,
                                              'title': item['title'],
                                              'imageUrl': item['imageUrl'],
                                              'offerPrice': item['offerPrice'],
                                              'quantity': 1,
                                            });

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text('Added to Cart'),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.red,
                                                content:
                                                    Text('Already in Cart'),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: const Text(
                                          'Add to Cart',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          // Remove from wishlist logic
                                          await FirebaseFirestore.instance
                                              .collection('wishlist')
                                              .doc(docId)
                                              .delete();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text('Removed from Wishlist'),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
