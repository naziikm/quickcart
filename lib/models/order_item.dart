class OrderItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    final priceValue = data['price'];
    return OrderItem(
      productId: (data['productId'] ?? '').toString(),
      name: (data['name'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      price: priceValue is num ? priceValue.toDouble() : 0.0,
      quantity: data['quantity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  double get totalPrice => price * quantity;
}
