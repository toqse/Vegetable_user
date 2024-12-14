import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../orderpayments/delivaryaddress.dart';

class ProductDetails extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const ProductDetails({Key? key, required this.products}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic>? productData;
  bool isWishlist = false;
  bool isInCart = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
    _checkWishlistStatus();
    _checkCartStatus();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('products')
          .where('title', isEqualTo: widget.products[0]['title'])
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          productData = query.docs.first.data();
        });
      } else {
        _showSnackbar('Product not found');
        Navigator.pop(context);
      }
    } catch (e) {
      _showSnackbar('Error fetching product details: $e');
    }
  }

  Future<void> _checkWishlistStatus() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('title', isEqualTo: widget.products[0]['title'])
          .where('userId',
              isEqualTo:
                  FirebaseAuth.instance.currentUser!.uid) // User-specific
          .get();

      setState(() {
        isWishlist = query.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking wishlist status: $e');
    }
  }

  Future<void> _checkCartStatus() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('cart')
          .where('title', isEqualTo: widget.products[0]['title'])
          .where('userId',
              isEqualTo:
                  FirebaseAuth.instance.currentUser!.uid) // User-specific
          .get();

      setState(() {
        isInCart = query.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking cart status: $e');
    }
  }

  Future<void> _addToCart() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      if (!isInCart) {
        await FirebaseFirestore.instance.collection('cart').add({
          'userId': userId, // Ensure user-specific
          'title': productData!['title'],
          'imageUrl': productData!['imageUrl'],
          'offerPrice': productData!['offerPrice'],
          'quantity': quantity,
        });
        setState(() {
          isInCart = true;
        });
        _showSnackbar('Added to Cart');
      } else {
        _showSnackbar('Already in Cart');
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> _toggleWishlist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      if (isWishlist) {
        // Remove from wishlist
        await FirebaseFirestore.instance
            .collection('wishlist')
            .where('title', isEqualTo: widget.products[0]['title'])
            .where('userId', isEqualTo: userId) // Ensure user-specific
            .get()
            .then((query) {
          for (var doc in query.docs) {
            doc.reference.delete();
          }
        });
        setState(() {
          isWishlist = false;
        });
        _showSnackbar('Removed from Wishlist');
      } else {
        // Add to wishlist
        await FirebaseFirestore.instance.collection('wishlist').add({
          'userId': userId, // Ensure user-specific
          'title': productData!['title'],
          'imageUrl': productData!['imageUrl'],
          'offerPrice': productData!['offerPrice'],
        });
        setState(() {
          isWishlist = true;
        });
        _showSnackbar('Added to Wishlist');
      }
    } catch (e) {
      print('Error toggling wishlist: $e');
    }
  }

  // Helper function to display a Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return Scaffold(
        appBar: AppBar(
          actions: [],
          title: const Text('Product Details',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Fetching product details from Firestore data
    final String title = productData!['title'] ?? 'No Title';
    final String imageUrl = productData!['imageUrl']?.toString() ?? '';
    final double offerPrice =
        double.tryParse(productData!['offerPrice']?.toString() ?? '0') ?? 0;
    final double totalPrice = offerPrice * quantity; // Calculate dynamically

    final double originalPrice =
        double.tryParse(productData!['originalPrice']?.toString() ?? '0') ?? 0;
    final String weight = productData!['weight']?.toString() ?? 'N/A';
    final String type = productData!['type']?.toString() ?? 'N/A';
    final String expiry = productData!['expiry']?.toString() ?? 'N/A';
    final String productDescription =
        productData!['productdescreption']?.toString() ??
            'No description available';

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // Image Carousel
          CarouselSlider(
            items: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ],
            options: CarouselOptions(
              height: 300,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.9,
              autoPlayCurve: Curves.easeInOut,
            ),
          ),
          const SizedBox(height: 16.0),

          // Product Info Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹$offerPrice',
                      style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      '₹$originalPrice',
                      style: const TextStyle(
                          fontSize: 16.0,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: IconButton(
                        icon: Icon(
                          isWishlist ? Icons.favorite : Icons.favorite_border,
                          color: isWishlist ? Colors.red : Colors.black,
                        ),
                        onPressed: _toggleWishlist,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quantity Selector
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quantity:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Product Details Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Product Details',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Text('• Weight: $weight'),
                Text('• Type: $type'),
                Text('• Expiry: $expiry'),
              ],
            ),
          ),

          // Product Description Section
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Product Description',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Text(productDescription,
                    style: const TextStyle(fontSize: 16.0)),
              ],
            ),
          ),

          // Add to Cart Button
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: _addToCart,
              child: const Text('Add to Cart',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(129, 107, 216, 103),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ₹$totalPrice',
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Purchase'),
                      content: Text(
                          'Are you sure you want to buy "$title" for ₹${(offerPrice * quantity).toStringAsFixed(2)}?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Delivery(
                                  products: [
                                    {
                                      'title': title,
                                      'quantity': quantity,
                                      'totalPrice': totalPrice,
                                      // Pass the calculated totalPrice
                                      'imageUrl': imageUrl,
                                    }
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Text('Buy Now'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Buy Now',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
