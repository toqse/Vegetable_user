class FeaturedBrandModel {
  // final String title;
  final String imageUrl;

  FeaturedBrandModel({required this.imageUrl});

  // Factory constructor to create a FeaturedBrandModel object from Firestore data
  factory FeaturedBrandModel.fromMap(Map<String, dynamic> data) {
    return FeaturedBrandModel(
      // title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert FeaturedBrandModel object to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      // 'title': title,
      'imageUrl': imageUrl,
    };
  }
}
