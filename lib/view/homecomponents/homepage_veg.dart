import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app2/models/home_veg_model.dart';
import 'package:ecom_app2/view/products/productdetails.dart';
import 'package:flutter/material.dart';

class BestOfferGrid extends StatelessWidget {
  const BestOfferGrid({Key? key}) : super(key: key);

  // Function to fetch data from Firebase collection "vegetables"
  Stream<List<BestOffer>> getVegetableOffers() {
    return FirebaseFirestore.instance
        .collection('vegetables')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return BestOffer(
          title:
              data['title'] as String? ?? 'Untitled', // Provide default title
          imageUrl: data['imageUrl'] as String? ?? '', // Provide default image
          originalPrice:
              double.tryParse(data['originalPrice'].toString()) ?? 0.0,
          offerPrice: double.tryParse(data['offerPrice'].toString()) ?? 0.0,
        );
      }).toList();
    });
  }

  InkWell getStructuredGridCell(BestOffer bestOffer, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              products: [
                {
                  'title': bestOffer.title, // Pass the actual product title
                  'imageUrl': bestOffer.imageUrl, // Pass the image URL
                  'originalPrice': bestOffer.originalPrice, // Original price
                  'offerPrice': bestOffer.offerPrice, // Offer price
                }
              ],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.green, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.network(
                    bestOffer.imageUrl,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported,
                          color: Colors.grey, size: 50);
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  bestOffer.title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${bestOffer.originalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 12.0,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "₹${bestOffer.offerPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BestOffer>>(
      stream: getVegetableOffers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        final vegetables = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Vegetables",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: const Text(
                                'All Vegetables',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              iconTheme: const IconThemeData(
                                color: Colors.white,
                              ),
                            ),
                            body: GridView.builder(
                              padding: const EdgeInsets.all(10.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemCount: vegetables.length,
                              itemBuilder: (context, index) {
                                return getStructuredGridCell(
                                    vegetables[index], context);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(1.0),
              alignment: Alignment.center,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: vegetables.length > 6 ? 6 : vegetables.length,
                itemBuilder: (context, index) {
                  return getStructuredGridCell(vegetables[index], context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
