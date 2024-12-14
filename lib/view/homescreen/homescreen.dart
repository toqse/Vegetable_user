import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom_app2/providers/carousal_image_provider/carousal_provider.dart';

// import 'package:ecom_app2/providers/middle_banner_image/middle_banner.dart';
import 'package:ecom_app2/view/homecomponents/homepage_veg.dart';
import 'package:ecom_app2/view/homecomponents/catagorygrid.dart';
import 'package:ecom_app2/view/homecomponents/drawer.dart';
import 'package:ecom_app2/view/homecomponents/featuredbrand.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/easy.png', // Path to your asset image
          height: 60.0,
          width: 160, // Adjust the height of the image
        ),
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the drawer icon color to white
        ),
      ),
      drawer: MainDrawer(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          // Carousel Slider with Provider
          Consumer<CarouselProvider>(
            builder: (context, carouselProvider, child) {
              if (carouselProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (carouselProvider.carouselImages.isEmpty) {
                return Center(child: Text('No images available'));
              }
              return CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  // Height of the carousel
                  autoPlay: true,
                  // Enables auto-scrolling
                  aspectRatio: 16 / 9,
                  // Aspect ratio for the carousel
                  viewportFraction: 1.0,
                  // Each image occupies full width
                  padEnds: true,
                  // Adds padding at the edges
                  autoPlayInterval: Duration(seconds: 5),
                  // Interval for autoplay
                  scrollDirection: Axis.horizontal,
                  // Horizontal scrolling
                  disableCenter: true, // Disable centering
                ),
                items: carouselProvider.carouselImages.map((carouselImage) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(
                            5.0), // Optional rounded corners
                        child: CachedNetworkImage(
                          imageUrl: carouselImage.imageUrl,
                          fit: BoxFit.fill,
                          // Ensures the image covers the available space
                          width: double.infinity,
                          // Image takes full width of the screen
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Center(
                              child: Icon(Icons.broken_image, size: 50.0)),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 2.0),
          CategoryGrid(),
          const SizedBox(height: 0.0),
          FeaturedBrandSlider(),
          BestOfferGrid(),
        ],
      ),
    );
  }
}
