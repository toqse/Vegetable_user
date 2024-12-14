import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app2/models/featured_brand_model.dart';
import 'package:ecom_app2/providers/featured_brand_slider_provider/featured_brand_slider_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../categories/featured_items.dart';

class FeaturedBrandSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final featuredBrandProvider =
        Provider.of<FeaturedBrandSliderProvider>(context);

    // Helper function to create a carousel item
    Widget getCarouselItem(FeaturedBrandModel featuredBrand) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeaturedBrandItems(title: 'featuredBrand'),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: featuredBrand.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Title
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: const Text(
              'Featured Brands',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Carousel Slider
          Container(
            height: 220.0,
            child: featuredBrandProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : featuredBrandProvider.featuredBrands.isEmpty
                    ? const Center(
                        child: Text(
                          "No featured brands available",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      )
                    : CarouselSlider.builder(
                        itemCount: featuredBrandProvider.featuredBrands.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          return getCarouselItem(
                              featuredBrandProvider.featuredBrands[index]);
                        },
                        options: CarouselOptions(
                          height: 200.0,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayCurve: Curves.easeInOut,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          padEnds: true,
                          disableCenter: false,
                          scrollDirection: Axis.horizontal,
                          enlargeCenterPage: true,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
