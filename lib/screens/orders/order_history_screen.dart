import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/orders_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_view.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order history'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return const EmptyState(
                title: 'No orders yet',
                message: 'Place your first order from the home screen.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                final date = order.createdAt == null
                    ? ''
                    : DateFormat('dd MMM, hh:mm a').format(order.createdAt!);
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  title: Text('Order #${order.id.substring(0, 6)}'),
                  subtitle: Text('${order.statusLabel} • $date'),
                  trailing: Text(
                    NumberFormat.currency(symbol: '\u20B9').format(order.total),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.orderDetail,
                      arguments: order,
                    );
                  },
                );
              },
            );
          },
          loading: () => const LoadingView(message: 'Loading orders...'),
          error: (error, stack) => EmptyState(
            title: 'Unable to load orders',
            message: error.toString(),
            icon: Icons.warning_amber_outlined,
          ),
        ),
      ),
    );
  }
}
