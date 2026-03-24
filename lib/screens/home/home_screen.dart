import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/product.dart';
import '../../providers/auth_controller.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Blinkit-style header
            _buildHeader(context, cartState),
            // Search bar
            _buildSearchBar(context),
            // Content
            Expanded(
              child: productsAsync.when(
                data: (products) => _buildContent(context, products),
                loading: () =>
                    const LoadingView(message: 'Loading products...'),
                error: (error, stack) => EmptyState(
                  title: 'Something went wrong',
                  message: error.toString(),
                  icon: Icons.warning_amber_outlined,
                ),
              ),
            ),
            // Sticky cart bar
            if (cartState.totalItems > 0) _buildCartBar(context, cartState),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildHeader(BuildContext context, CartState cartState) {
    return Container(
      color: BlinkitApp.blinkitYellow,
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.black54, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery in',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Row(
                  children: [
                    Text(
                      '10 minutes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
                Text(
                  'Home - Select delivery address',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                icon: const Icon(Icons.shopping_cart_outlined, size: 26),
              ),
              if (cartState.totalItems > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: BlinkitApp.blinkitGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartState.totalItems.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.search),
      child: Container(
        color: BlinkitApp.blinkitYellow,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade500, size: 22),
              const SizedBox(width: 8),
              Text(
                'Search "groceries"',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Product> products) {
    // Group by category
    final categories = <String>{};
    for (final p in products) {
      categories.add(p.category);
    }
    final sortedCategories = categories.toList()..sort();

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        // Banner section
        _buildBannerSection(),
        const SizedBox(height: 16),
        // Category grid
        _buildCategoryGrid(context, sortedCategories),
        const SizedBox(height: 20),
        // Products by category
        for (final category in sortedCategories) ...[
          _buildCategorySection(context, category, products),
        ],
      ],
    );
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 140,
      child: PageView(
        padEnds: false,
        controller: PageController(viewportFraction: 0.9),
        children: [
          _bannerCard(
            'Fresh Vegetables',
            'Up to 30% off',
            Colors.green.shade50,
            Icons.eco,
          ),
          _bannerCard(
            'Dairy & Breakfast',
            'Starting ₹20',
            Colors.orange.shade50,
            Icons.free_breakfast,
          ),
          _bannerCard(
            'Munchies & Snacks',
            'Buy 2 Get 1',
            Colors.purple.shade50,
            Icons.fastfood,
          ),
        ],
      ),
    );
  }

  Widget _bannerCard(
    String title,
    String subtitle,
    Color bgColor,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, size: 52, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, List<String> categories) {
    final categoryIcons = {
      'Vegetables': Icons.eco,
      'Fruits': Icons.apple,
      'Dairy': Icons.water_drop,
      'Snacks': Icons.cookie,
      'Beverages': Icons.local_cafe,
      'Bakery': Icons.bakery_dining,
      'Household': Icons.home,
    };

    final categoryColors = {
      'Vegetables': Colors.green.shade50,
      'Fruits': Colors.red.shade50,
      'Dairy': Colors.blue.shade50,
      'Snacks': Colors.orange.shade50,
      'Beverages': Colors.brown.shade50,
      'Bakery': Colors.amber.shade50,
      'Household': Colors.purple.shade50,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shop by category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.categoryProducts,
                  arguments: cat,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: categoryColors[cat] ?? Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        categoryIcons[cat] ?? Icons.category,
                        color: Colors.grey.shade700,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String category,
    List<Product> all,
  ) {
    final products = all.where((p) => p.category == category).toList();
    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.categoryProducts,
                    arguments: category,
                  ),
                  child: const Text('see all'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductTile(context, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, Product product) {
    final cartController = ref.read(cartProvider.notifier);
    final cartState = ref.watch(cartProvider);
    final inCart = cartState.items[product.id];
    final price = NumberFormat.currency(
      symbol: '\u20B9',
      decimalDigits: 0,
    ).format(product.price);

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.product, arguments: product),
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.imageUrl.isEmpty
                    ? Container(
                        color: Colors.grey.shade100,
                        child: const Center(child: Icon(Icons.image, size: 40)),
                      )
                    : Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Icon(Icons.image, size: 40),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Text(
              product.unit,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                if (inCart != null)
                  Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: BlinkitApp.blinkitGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => cartController.updateQuantity(
                            product,
                            inCart.quantity - 1,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.remove,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          '${inCart.quantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        InkWell(
                          onTap: () => cartController.updateQuantity(
                            product,
                            inCart.quantity + 1,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: () => cartController.addProduct(product),
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: BlinkitApp.blinkitGreen),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          'ADD',
                          style: TextStyle(
                            color: BlinkitApp.blinkitGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartBar(BuildContext context, CartState cartState) {
    final total = NumberFormat.currency(
      symbol: '\u20B9',
      decimalDigits: 0,
    ).format(cartState.totalPrice);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: BlinkitApp.blinkitGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${cartState.totalItems} item${cartState.totalItems > 1 ? 's' : ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              total,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            const Text(
              'View Cart',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: BlinkitApp.blinkitYellow),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Text(
                  'Blinkit',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart_outlined),
            title: const Text('My Cart'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.orders);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.root,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
