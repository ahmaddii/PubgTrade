import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pubg/screens/help_and_support_screen.dart';
import 'package:pubg/screens/my_account_screen.dart';
import 'package:pubg/screens/wallet_screen.dart';
import 'favorites_screen.dart';
import 'my_account_screen.dart';
import 'wallet_screen.dart';
import 'setting_screen.dart';
import 'help_and_support_screen.dart';
import 'About_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make status bar transparent with white icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // AppBar with gradient background
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.orange.shade900, Colors.black],
                  ),
                ),
              ),
            ),
          ),

          // Profile body
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -2), // pull profile picture up
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 4),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person, size: 50, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name + Username
                  const Text(
                    'GamerPro',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@gamerpro123',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('15', 'Accounts'),
                        _buildVerticalDivider(),
                        _buildStat('8', 'Sold'),
                        _buildVerticalDivider(),
                        _buildStat('4.8', 'Rating'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Edit Profile Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Menu items
                  _buildMenuItem(
                    context,
                    icon: Icons.inventory_2_outlined,
                    title: 'My Accounts',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyAccountsScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'Purchase History',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.favorite_border,
                    title: 'Favorites',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Wallet',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WalletScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {},
                    isDestructive: true,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stats Widget
  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // Divider between stats
  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[800]);
  }

  // Menu item widget
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[900]!, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDestructive ? Colors.red : Colors.white,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
