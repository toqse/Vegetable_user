class Category {
  final String id; // Add this field for the unique identifier
  final String title;
  final String imageUrl;

  Category({required this.id, required this.title, required this.imageUrl});

  // Convert Firestore document to Category object
  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      id: documentId, // Set the document ID here
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
