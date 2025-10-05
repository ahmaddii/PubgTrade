import 'package:flutter/material.dart';
import 'package:pubg/screens/account_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pubg/screens/account_detail_screen.dart';

// Account Model
class AccountModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String sellerName;
  final List<String> images;
  final String tier;
  final double kd;
  final int matches;
  final int skins;
  final int favorites;

  AccountModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sellerName,
    required this.images,
    required this.tier,
    required this.kd,
    required this.matches,
    required this.skins,
    this.favorites = 0,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] != null
          ? double.tryParse(map['price'].toString()) ?? 0
          : 0,
      sellerName: map['seller_name'] ?? '',
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      tier: map['tier'] ?? '',
      kd: map['kd'] != null ? double.tryParse(map['kd'].toString()) ?? 0 : 0,
      matches: map['matches'] ?? 0,
      skins: map['skins'] ?? 0,
      favorites: map['favorites'] ?? 0,
    );
  }
}

// HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<AccountModel> accounts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchAccounts() async {
    setState(() => isLoading = true);
    try {
      final data = await Supabase.instance.client
          .from('accounts')
          .select()
          .order('created_at', ascending: false);

      accounts = (data as List)
          .map((e) => AccountModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Supabase Error: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (accounts.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No accounts available',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'PUBG Accounts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: accounts.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          return AccountCard(
            account: accounts[index],
            isActive: _currentPage == index,
          );
        },
      ),
    );
  }
}

// Account Card Widget
class AccountCard extends StatelessWidget {
  final AccountModel account;
  final bool isActive;

  const AccountCard({Key? key, required this.account, required this.isActive})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountDetailScreen(account: account),
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image or gradient
          account.images.isNotEmpty
              ? Image.network(
                  account.images[0],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.orange.shade900, Colors.black],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.sports_esports,
                      size: 120,
                      color: Colors.white24,
                    ),
                  ),
                ),

          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              ),
            ),
          ),

          // Content
          Positioned(
            left: 16,
            right: 16,
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tier Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    account.tier,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  account.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Stats
                Row(
                  children: [
                    _buildStat('KD', account.kd.toString()),
                    const SizedBox(width: 16),
                    _buildStat('Matches', '${account.matches}+'),
                    const SizedBox(width: 16),
                    _buildStat('Skins', '${account.skins}+'),
                  ],
                ),
                const SizedBox(height: 12),
                // Seller Info
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      account.sellerName,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Price
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Rs ${account.price}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Horizontal carousel of images
                if (account.images.length > 1)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: account.images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              account.images[index],
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
