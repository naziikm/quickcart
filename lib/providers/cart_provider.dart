import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartState {
  final Map<String, CartItem> items;

  const CartState({this.items = const {}});

  List<CartItem> get itemList => items.values.toList();

  double get totalPrice {
    return items.values.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return items.values.fold(0, (sum, item) => sum + item.quantity);
  }
}

class CartController extends StateNotifier<CartState> {
  CartController() : super(const CartState());

  void addProduct(Product product, {int quantity = 1}) {
    final existing = state.items[product.id];
    final updatedQuantity = (existing?.quantity ?? 0) + quantity;
    state = CartState(
      items: {
        ...state.items,
        product.id: CartItem(product: product, quantity: updatedQuantity),
      },
    );
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeProduct(product.id);
      return;
    }
    state = CartState(
      items: {
        ...state.items,
        product.id: CartItem(product: product, quantity: quantity),
      },
    );
  }

  void removeProduct(String productId) {
    final updated = Map<String, CartItem>.from(state.items);
    updated.remove(productId);
    state = CartState(items: updated);
  }

  void clear() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartController, CartState>((ref) {
  return CartController();
});
