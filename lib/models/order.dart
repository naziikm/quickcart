import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';
import 'order_item.dart';

enum OrderStatus { placed, preparing, outForDelivery, delivered }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.outForDelivery:
        return 2;
      case OrderStatus.delivered:
        return 3;
    }
  }
}

OrderStatus orderStatusFromValue(String? value) {
  switch (value) {
    case 'preparing':
      return OrderStatus.preparing;
    case 'outForDelivery':
      return OrderStatus.outForDelivery;
    case 'delivered':
      return OrderStatus.delivered;
    case 'placed':
    default:
      return OrderStatus.placed;
  }
}

class Order {
  final String id;
  final String userId;
  final Address address;
  final List<OrderItem> items;
  final OrderStatus status;
  final double total;
  final DateTime? createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.address,
    required this.items,
    required this.status,
    required this.total,
    required this.createdAt,
  });

  factory Order.fromMap(String id, Map<String, dynamic> data) {
    final itemsData = data['items'] as List<dynamic>? ?? [];
    final createdAt = data['createdAt'];
    DateTime? createdAtValue;
    if (createdAt is Timestamp) {
      createdAtValue = createdAt.toDate();
    } else if (createdAt is DateTime) {
      createdAtValue = createdAt;
    }

    return Order(
      id: id,
      userId: (data['userId'] ?? '').toString(),
      address: Address.fromMap(data['address'] as Map<String, dynamic>? ?? {}),
      items: itemsData
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      status: orderStatusFromValue(data['status']?.toString()),
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      createdAt: createdAtValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'address': address.toMap(),
      'items': items.map((item) => item.toMap()).toList(),
      'status': status.name,
      'total': total,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  /// Human readable label for the current order status.
  String get statusLabel => status.label;

  /// Numeric index for the current order status steps.
  int get statusIndex => status.stepIndex;
}
