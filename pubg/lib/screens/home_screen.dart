import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'account_detail_screen.dart';
import 'package:pubg/models/account_model.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> fetchAccounts() async {
    setState(() => isLoading = true);

    try {
      final data = await Supabase.instance.client
          .from('accounts')
          .select()
          .order('created_at', ascending: false);

      accounts = data
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'PUBG Accounts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : accounts.isEmpty
          ? const Center(
              child: Text(
                'No accounts found',
                style: TextStyle(color: Colors.white),
              ),
            )
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: accounts.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => AccountCard(
                account: accounts[index],
                isActive: _currentPage == index,
              ),
            ),
    );
  }
}

class AccountCard extends StatefulWidget {
  final AccountModel account;
  final bool isActive;

  const AccountCard({Key? key, required this.account, required this.isActive})
    : super(key: key);

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  late int _favoritesCount;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _favoritesCount = widget.account.favorites;
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    // Optimistically update UI
    setState(() {
      _isFavorited = !_isFavorited;
      _favoritesCount = _isFavorited
          ? _favoritesCount + 1
          : _favoritesCount - 1;
    });

    try {
      // Update database
      await Supabase.instance.client
          .from('accounts')
          .update({'favorites': _favoritesCount})
          .eq('id', widget.account.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorited ? 'Added to favorites!' : 'Removed from favorites',
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Revert on error
      setState(() {
        _isFavorited = !_isFavorited;
        _favoritesCount = _isFavorited
            ? _favoritesCount + 1
            : _favoritesCount - 1;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image Carousel with proper gesture handling
        widget.account.images.isNotEmpty
            ? PageView.builder(
                controller: _imagePageController,
                itemCount: widget.account.images.length,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentImageIndex = index);
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade900,
                          Colors.deepOrange.shade800,
                          Colors.black,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Image.network(
                        widget.account.images[index],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.orange,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.white24,
                              ),
                            ),
                      ),
                    ),
                  );
                },
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

        // Overlay gradient
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),

        // Dots Indicator (TikTok style - top center)
        if (widget.account.images.length > 1)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.account.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentImageIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Left side content - positioned at the very bottom like TikTok
        Positioned(
          left: 16,
          right: 80,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tier badge
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
                  widget.account.tier,
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
                widget.account.title,
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
                  _buildStat('KD', widget.account.kd.toString()),
                  const SizedBox(width: 16),
                  _buildStat('Matches', '${widget.account.matches}+'),
                  const SizedBox(width: 16),
                  _buildStat('Skins', '${widget.account.skins}+'),
                ],
              ),
              const SizedBox(height: 12),
              // Seller name - Clickable
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AccountDetailScreen(account: widget.account),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      widget.account.sellerName,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
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
                  'Rs ${widget.account.price}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Right side actions - TikTok style
        Positioned(
          right: 12,
          bottom: 20,
          child: Column(
            children: [
              // Profile Avatar - Clickable
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AccountDetailScreen(account: widget.account),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.person,
                          size: 26,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Favorite Icon with dynamic count - Clickable
              GestureDetector(
                onTap: _toggleFavorite,
                child: _buildActionButton(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  _formatCount(_favoritesCount),
                  color: _isFavorited ? Colors.red : Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Share Icon - Clickable
              GestureDetector(
                onTap: () {
                  final shareText =
                      '''
                      Check out this PUBG account! 🎮🔥
                      Title: ${widget.account.title}
                      Tier: ${widget.account.tier}
                      KD: ${widget.account.kd}
                      Matches: ${widget.account.matches}
                      Price: Rs ${widget.account.price}

                      Seller: ${widget.account.sellerName}
    ''';

                  // If account has images, share the first one (optional)
                  if (widget.account.images.isNotEmpty) {
                    Share.share(shareText, subject: "PUBG Account for Sale");
                  } else {
                    Share.share(shareText, subject: "PUBG Account for Sale");
                  }
                },
                child: _buildActionButton(Icons.share, 'Share'),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildActionButton(IconData icon, String label, {Color? color}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color ?? Colors.white, size: 28),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Format count to display K for thousands
  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1).replaceAll('.0', '')}K';
    }
    return count.toString();
  }
}
