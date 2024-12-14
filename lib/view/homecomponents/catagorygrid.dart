import 'package:flutter/material.dart';
import '../../categories/fruit.dart';
import '../../categories/poultry.dart';
import '../../categories/spices.dart';
import '../../categories/veggies.dart';

class CategoryGrid extends StatelessWidget {
  // Example data for categories
  final List<String> pages = [
    'Page1',
    'Page2',
    'Page3',
    'Page4',
  ];

  final List<String> data = [
    'Vegetables',
    'Fruits',
    'Spices',
    'Poultry',
  ];

  final List<String> images = [
    'assets/carrots_7142554.png', // Asset image for Organic Vegetables
    'assets/fruit1.png', // Asset image for Fruits
    'assets/spices.png', // Asset image for Spices
    'assets/egg1.png', // Asset image for Poultry
  ];

  final double cardHeight = 50; // Further reduced height
  final double cardWidth = 50; // Further reduced width

  // Define the refactored widget for smaller cards with asset images
  Widget refactor({
    required VoidCallback ontap,
    required String name,
    required String imagePath,
    required double cardHeight,
    required double cardWidth,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: SizedBox(
        height: cardHeight, // Set fixed height for the card
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: cardHeight / 1.5, // Adjusted image size
                width: cardWidth / 1.5, // Adjusted image width
                fit: BoxFit.contain, // Fit the image inside the card
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading Text
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Categories', // Heading text
            style: TextStyle(
              fontSize: 16, // Larger font size for heading
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.14, // Adjusted grid height
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: GridView.builder(
                itemCount: pages.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Four items per row for smaller cards
                  childAspectRatio: 1, // Makes the grid items square
                  crossAxisSpacing:
                      4.0, // Reduced spacing between items horizontally
                  mainAxisSpacing:
                      2.0, // Reduced spacing between items vertically
                ),
                itemBuilder: (context, index) {
                  return refactor(
                    ontap: () {
                      // Navigate to the specific page based on the index
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            switch (index) {
                              case 0:
                                return VeggiesPage(title: data[index]);
                              case 1:
                                return Fruits(title: data[index]);
                              case 2:
                                return Spices(title: data[index]);
                              case 3:
                                return Poultry(title: data[index]);
                              default:
                                return Scaffold(
                                  appBar:
                                      AppBar(title: const Text("Unknown Page")),
                                  body: const Center(
                                    child:
                                        Text("No page defined for this item."),
                                  ),
                                );
                            }
                          },
                        ),
                      );
                    },
                    name: data[index],
                    // Title or data for the item
                    imagePath: images[index],
                    // Asset image for the item
                    cardHeight: cardHeight,
                    // Reduced height for smaller cards
                    cardWidth: cardWidth, // Reduced width for smaller cards
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
