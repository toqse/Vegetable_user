class FeaturedBrandMode2 {
  // final String title;
  final String imageUrl;

  FeaturedBrandMode2({required this.imageUrl});

  // Factory constructor to create a FeaturedBrandModel object from Firestore data
  factory FeaturedBrandMode2.fromMap(Map<String, dynamic> data) {
    return FeaturedBrandMode2(
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
