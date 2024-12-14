import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app2/models/featured_brand2_model.dart';
import 'package:flutter/material.dart';

class FeaturedBrandSliderProvider2 extends ChangeNotifier {
  final CollectionReference _featuredBrandCollection =
      FirebaseFirestore.instance.collection('featured_brand_slider');

  List<FeaturedBrandMode2> _featuredBrands = [];
  bool _isLoading = true;

  List<FeaturedBrandMode2> get featuredBrands => _featuredBrands;

  bool get isLoading => _isLoading;

  FeaturedBrandSliderProvider() {
    fetchFeaturedBrands();
  }

  Future<void> fetchFeaturedBrands() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _featuredBrandCollection.get();
      _featuredBrands = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FeaturedBrandMode2(
          imageUrl: data['imageUrl']?.toString() ?? '', // Fetch only imageUrl
        );
      }).toList();
    } catch (e) {
      print("Error fetching featured brands: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
