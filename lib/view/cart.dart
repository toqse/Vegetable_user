import 'package:ecom_app2/view/orderpayments/delivaryaddress.dart';
import 'package:ecom_app2/view/products/productdetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> deleteCartItem(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('cart').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item Removed")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error removing item: $e")),
      );
    }
  }

  Future<void> clearCart() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cart cleared successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error clearing cart: $e")),
      );
    }
  }

  double calculateTotal(List<QueryDocumentSnapshot> cartItems) {
    double total = 0.0;
    for (var item in cartItems) {
      final data = item.data() as Map<String, dynamic>;
      final price = double.tryParse(data['offerPrice'].toString()) ?? 0.0;
      final quantity = data['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No items in the cart"));
          }

          final cartItems = snapshot.data!.docs;
          final totalAmount = calculateTotal(cartItems);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final itemData =
                        cartItems[index].data() as Map<String, dynamic>;
                    final docId = cartItems[index].id;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      elevation: 5,
                      child: ListTile(
                        leading: Image.network(
                          itemData['imageUrl'] ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(itemData['title'] ?? 'No Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('₹${itemData['offerPrice']}'),
                            Text('Quantity: ${itemData['quantity']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteCartItem(docId),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                products: [
                                  {
                                    'productId': docId,
                                    'title': itemData['title'] ?? 'No Title',
                                    'imageUrl': itemData['imageUrl'] ?? '',
                                    'offerPrice': itemData['offerPrice'] ?? '0',
                                    'originalPrice':
                                        itemData['originalPrice'] ?? '0',
                                  }
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total: ₹${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: BottomAppBar(
                      height: 95,
                      elevation: 8,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final products = cartItems.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return {
                                'productId': doc.id,
                                'title': data['title'],
                                'imageUrl': data['imageUrl'],
                                'offerPrice': data['offerPrice'],
                                'quantity': data['quantity'],
                              };
                            }).toList();

                            // Navigate to delivery page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Delivery(products: products),
                              ),
                            );

                            // Clear the cart after successful navigation
                            await clearCart();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                230, 77, 172, 80), // Button color
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                          icon: const Icon(Icons.shopping_bag,
                              color: Colors.white),
                          label: const Text(
                            'Buy Now',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
