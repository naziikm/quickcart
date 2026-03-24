import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/order.dart';
import '../../routes/app_routes.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final steps = OrderStatus.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order tracking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Order #${order.id.substring(0, 6)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text('Current status: ${order.statusLabel}'),
            const SizedBox(height: 24),
            ...steps.map(
              (status) => _StatusTile(
                status: status.label,
                isCompleted: status.stepIndex <= order.statusIndex,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Delivery Address',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(order.address.formatted),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final String status;
  final bool isCompleted;

  const _StatusTile({required this.status, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? BlinkitApp.blinkitGreen : Colors.grey.shade400,
          ),
          const SizedBox(width: 12),
          Text(status, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
