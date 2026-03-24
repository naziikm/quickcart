import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order.dart';
import '../services/order_service.dart';
import 'auth_controller.dart';
import 'firebase_providers.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService(ref.read(firestoreProvider));
});

final ordersProvider = StreamProvider<List<Order>>((ref) {
  final authState = ref.watch(authStateProvider).value;
  if (authState == null) {
    return Stream<List<Order>>.empty();
  }
  return ref.read(orderServiceProvider).watchOrders(authState.uid);
});

final orderByIdProvider = StreamProvider.family<Order?, String>((ref, orderId) {
  return ref.read(orderServiceProvider).watchOrder(orderId);
});
