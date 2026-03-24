import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../models/order.dart' as model;

class OrderService {
  OrderService(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> createOrder(model.Order order) {
    return _firestore.collection('orders').doc(order.id).set(order.toMap());
  }

  Stream<List<model.Order>> watchOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => model.Order.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<model.Order?> watchOrder(String orderId) {
    return _firestore
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map(
          (doc) => doc.exists ? model.Order.fromMap(doc.id, doc.data()!) : null,
        );
  }
}
