import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import 'firebase_providers.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(ref.read(firestoreProvider));
});

final productsProvider = StreamProvider<List<Product>>((ref) {
  return ref.read(productServiceProvider).watchProducts();
});
