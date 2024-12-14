import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app2/dummy/dummymodel.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      _products = querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data());
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
