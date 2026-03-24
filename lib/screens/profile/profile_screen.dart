import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../providers/auth_controller.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Profile header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: BlinkitApp.blinkitYellow,
                  child: Icon(
                    Icons.person,
                    size: 44,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  authUser?.email ?? authUser?.phoneNumber ?? 'User',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (authUser?.uid != null)
                  Text(
                    'UID: ${authUser!.uid.substring(0, 8)}...',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          _ProfileTile(
            icon: Icons.receipt_long_outlined,
            title: 'My Orders',
            onTap: () => Navigator.pushNamed(context, AppRoutes.orders),
          ),
          _ProfileTile(
            icon: Icons.shopping_cart_outlined,
            title: 'My Cart',
            onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
          _ProfileTile(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address is saved during checkout'),
                ),
              );
            },
          ),
          _ProfileTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact: support@blinkit.com')),
              );
            },
          ),
          _ProfileTile(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Blinkit',
                applicationVersion: '1.0.0',
                children: [const Text('Grocery delivery in minutes.')],
              );
            },
          ),
          const Divider(height: 1),
          _ProfileTile(
            icon: Icons.logout,
            title: 'Logout',
            iconColor: Colors.red,
            titleColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ref.read(authControllerProvider.notifier).signOut();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.root,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Blinkit v1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}
