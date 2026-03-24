import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/address.dart';
import '../../models/order.dart';
import '../../models/order_item.dart';
import '../../providers/address_provider.dart';
import '../../providers/auth_controller.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  bool _placingOrder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final savedAddress = ref.read(addressProvider);
    if (savedAddress != null && _nameController.text.isEmpty) {
      _nameController.text = savedAddress.name;
      _phoneController.text = savedAddress.phone;
      _line1Controller.text = savedAddress.line1;
      _line2Controller.text = savedAddress.line2;
      _cityController.text = savedAddress.city;
      _stateController.text = savedAddress.state;
      _zipController.text = savedAddress.zipCode;
    }
    super.didChangeDependencies();
  }

  Future<void> _placeOrder() async {
    final cartState = ref.read(cartProvider);
    final authUser = ref.read(authStateProvider).value;
    if (authUser == null) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _placingOrder = true);

    final address = Address(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      line1: _line1Controller.text.trim(),
      line2: _line2Controller.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipController.text.trim(),
    );

    final items = cartState.itemList
        .map(
          (item) => OrderItem(
            productId: item.product.id,
            name: item.product.name,
            imageUrl: item.product.imageUrl,
            price: item.product.price,
            quantity: item.quantity,
          ),
        )
        .toList();

    final order = Order(
      id: const Uuid().v4(),
      userId: authUser.uid,
      address: address,
      items: items,
      status: OrderStatus.placed,
      total: cartState.totalPrice,
      createdAt: DateTime.now(),
    );

    await ref.read(orderServiceProvider).createOrder(order);
    ref.read(addressProvider.notifier).state = address;
    ref.read(cartProvider.notifier).clear();

    if (!mounted) {
      return;
    }

    setState(() => _placingOrder = false);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.orderTracking,
      arguments: order,
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final totalText = NumberFormat.currency(
      symbol: '\u20B9',
    ).format(cartState.totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Delivery Address',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Name is required.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Phone is required.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _line1Controller,
                decoration: const InputDecoration(
                  labelText: 'Address line 1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Address line 1 is required.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _line2Controller,
                decoration: const InputDecoration(
                  labelText: 'Address line 2',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'City is required.'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'State is required.'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _zipController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ZIP code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'ZIP code is required.'
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: const Text('Cash on Delivery'),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
              const SizedBox(height: 24),
              Text(
                'Order Summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...cartState.itemList.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.product.name),
                  subtitle: Text('Qty ${item.quantity}'),
                  trailing: Text(
                    NumberFormat.currency(
                      symbol: '\u20B9',
                    ).format(item.totalPrice),
                  ),
                ),
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    totalText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Place order',
                isLoading: _placingOrder,
                onPressed: cartState.itemList.isEmpty ? null : _placeOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
