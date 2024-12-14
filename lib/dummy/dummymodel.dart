class Product {
  final String title;
  final int productId;
  final String category;
  final String image;
  final double price;
  final double oldPrice;
  final String offer;

  Product({
    required this.title,
    required this.productId,
    required this.category,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.offer,
  });

  // Factory method to create a Product from Firestore document
  factory Product.fromFirestore(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      productId: json['productId'],
      category: json['category'],
      image: json['image'],
      price: json['price'].toDouble(),
      oldPrice: json['oldPrice'].toDouble(),
      offer: json['offer'],
    );
  }
}
