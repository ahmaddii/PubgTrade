import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pubg/models/account_model.dart';
import 'account_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<AccountModel> favoriteAccounts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    setState(() => isLoading = true);

    try {
      // Fetch accounts where user has favorited them
      // For now, we'll fetch accounts with favorites > 0
      // You can modify this query based on your user_favorites table structure
      final data = await Supabase.instance.client
          .from('accounts')
          .select()
          .gt('favorites', 0)
          .order('favorites', ascending: false);

      favoriteAccounts = data
          .map((e) => AccountModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'My Favorites',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : favoriteAccounts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start exploring and save your favorite accounts',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchFavorites,
                  color: Colors.orange,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: favoriteAccounts.length,
                    itemBuilder: (context, index) {
                      final account = favoriteAccounts[index];
                      return FavoriteAccountCard(
                        account: account,
                        onRemove: () {
                          setState(() {
                            favoriteAccounts.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                ),
    );
  }
}

class FavoriteAccountCard extends StatelessWidget {
  final AccountModel account;
  final VoidCallback onRemove;

  const FavoriteAccountCard({
    Key? key,
    required this.account,
    required this.onRemove,
  }) : super(key: key);

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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: account.images.isNotEmpty
                        ? Image.network(
                            account.images[0],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.orange.shade900,
                                    Colors.black,
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.sports_esports,
                                  size: 40,
                                  color: Colors.white24,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.orange.shade900,
                                  Colors.black,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.sports_esports,
                                size: 40,
                                color: Colors.white24,
                              ),
                            ),
                          ),
                  ),
                  // Tier badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        account.tier,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        // Remove from favorites
                        try {
                          await Supabase.instance.client
                              .from('accounts')
                              .update({'favorites': account.favorites - 1})
                              .eq('id', account.id);
                          
                          onRemove();
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Removed from favorites'),
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${account.favorites}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        account.kd.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rs ${account.price}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}