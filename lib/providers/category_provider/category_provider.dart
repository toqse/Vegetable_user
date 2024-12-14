import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app2/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;

  bool get isLoading => _isLoading;

  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('Category_Grid');

  // Fetch categories from Firebase
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _categoryCollection.get();
      _categories = snapshot.docs.map((doc) {
        return Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
