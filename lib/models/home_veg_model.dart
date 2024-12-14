class BestOffer {
  final String title;
  final String imageUrl;
  final double originalPrice;
  final double offerPrice;

  BestOffer({
    required this.title,
    required this.imageUrl,
    required this.originalPrice,
    required this.offerPrice,
  });

  // Convert Firestore data to BestOffer object
  factory BestOffer.fromMap(Map<String, dynamic> data) {
    return BestOffer(
      title: data['title'] ?? 'Untitled',
      imageUrl: data['imageUrl'] ?? '',
      originalPrice: (data['originalPrice'] as num?)?.toDouble() ?? 0.0,
      offerPrice: (data['offerPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convert BestOffer object to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'originalPrice': originalPrice,
      'offerPrice': offerPrice,
    };
  }
}
