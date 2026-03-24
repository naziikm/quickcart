import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String unit;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.unit,
    required this.isAvailable,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    final priceValue = data['price'];
    return Product(
      id: id,
      name: (data['name'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      price: priceValue is num ? priceValue.toDouble() : 0.0,
      imageUrl: (data['imageUrl'] ?? '').toString(),
      category: (data['category'] ?? 'Other').toString(),
      unit: (data['unit'] ?? '').toString(),
      isAvailable: data['isAvailable'] as bool? ?? true,
    );
  }

  factory Product.fromDoc(DocumentSnapshot doc) {
    return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'unit': unit,
      'isAvailable': isAvailable,
    };
  }
}
