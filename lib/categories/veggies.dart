import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app2/view/products/productdetails.dart';

class VeggiesPage extends StatefulWidget {
  const VeggiesPage({required this.title, Key? key}) : super(key: key);
  final String title;

  @override
  State<VeggiesPage> createState() => _VeggiesPageState();
}

class _VeggiesPageState extends State<VeggiesPage> {
  final Set<String> _wishlist = {};

  @override
  void initState() {
    super.initState();
    _syncVegetablesWithProducts();
  }

  /// Synchronize the vegetables collection with the products collection
  Future<void> _syncVegetablesWithProducts() async {
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.removed) {
          FirebaseFirestore.instance
              .collection('vegetables')
              .doc(docChange.doc.id)
              .delete();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vegetables',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vegetables').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No vegetables available"));
          }

          final veggies = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Construct the full image URL if necessary
            final imageUrl = (data['imageUrl']?.startsWith('http') == true)
                ? data['imageUrl']
                : 'https://firebasestorage.googleapis.com/v0/b/vegetableshop-479d4.appspot.com/o/${Uri.encodeComponent(data['imageUrl'] ?? '')}?alt=media';

            return _veggieCard(
              productId: doc.id,
              title: data['title'] ?? 'No Title',
              imageUrl: imageUrl,
              offerPrice: (data['offerPrice'] ?? 0).toString(),
              originalPrice: (data['originalPrice'] ?? 0).toString(),
              context: context,
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.75,
              children: veggies,
            ),
          );
        },
      ),
    );
  }

  Widget _veggieCard({
    required String productId,
    required String title,
    required String imageUrl,
    required String offerPrice,
    required String originalPrice,
    required BuildContext context,
  }) {
    final isAddedToWishlist = _wishlist.contains(productId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              products: [
                {
                  'productId': productId,
                  'title': title,
                  'imageUrl': imageUrl,
                  'offerPrice': offerPrice,
                  'originalPrice': originalPrice,
                }
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 50);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            "\₹$offerPrice",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "\₹$originalPrice",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
