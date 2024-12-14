import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app2/models/carousal_image_model.dart';
import 'package:flutter/material.dart';

class CarouselProvider with ChangeNotifier {
  List<CarouselImage> _carouselImages = [];
  bool _isLoading = false;

  List<CarouselImage> get carouselImages => _carouselImages;

  bool get isLoading => _isLoading;

  CarouselProvider() {
    fetchCarouselImages();
  }

  Future<void> fetchCarouselImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Fetching carousel images from Firestore...");

      // Fetch images from Firestore collection named "carousal_images"
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('carousal_images').get();

      // Check if documents are fetched
      print("Documents fetched: ${snapshot.docs.length}");

      // Map each document to a CarouselImage model and filter invalid URLs
      _carouselImages = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CarouselImage.fromMap(data);
          })
          .where((carouselImage) => carouselImage.imageUrl.isNotEmpty)
          .toList();

      print("Valid URLs: ${_carouselImages.map((e) => e.imageUrl).toList()}");
    } catch (e) {
      print("Error fetching carousel images: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
