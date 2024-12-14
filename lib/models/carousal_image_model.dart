class CarouselImage {
  final String imageUrl;

  CarouselImage({required this.imageUrl});

  // Factory method to create an instance from a Firebase document
  factory CarouselImage.fromMap(Map<String, dynamic> data) {
    return CarouselImage(
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
