import 'package:flutter/material.dart';

import '../models/order.dart';
import '../models/product.dart';
import '../screens/auth/auth_gate.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/phone_login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/home/category_products_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/search_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../screens/orders/order_history_screen.dart';
import '../screens/orders/order_tracking_screen.dart';
import '../screens/product/product_details_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/empty_state.dart';

class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String phoneLogin = '/phone-login';
  static const String home = '/home';
  static const String search = '/search';
  static const String categoryProducts = '/category-products';
  static const String product = '/product';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String orderTracking = '/order-tracking';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case phoneLogin:
        return MaterialPageRoute(builder: (_) => const PhoneLoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case categoryProducts:
        final category = settings.arguments as String?;
        if (category == null) {
          return _errorRoute('Category data missing');
        }
        return MaterialPageRoute(
          builder: (_) => CategoryProductsScreen(category: category),
        );
      case product:
        final product = settings.arguments as Product?;
        if (product == null) {
          return _errorRoute('Product data missing');
        }
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case orders:
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());
      case orderDetail:
        final order = settings.arguments as Order?;
        if (order == null) {
          return _errorRoute('Order data missing');
        }
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(order: order),
        );
      case orderTracking:
        final order = settings.arguments as Order?;
        if (order == null) {
          return _errorRoute('Order data missing');
        }
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(order: order),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return _errorRoute('Route not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: EmptyState(
          title: 'Oops',
          message: message,
          icon: Icons.error_outline,
        ),
      ),
    );
  }
}
