import 'package:flutter/material.dart';
import '../models/account_model.dart';
import 'chat_screen.dart';

class AccountDetailScreen extends StatefulWidget {
  final AccountModel account;

  const AccountDetailScreen({Key? key, required this.account})
    : super(key: key);

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image Carousel
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
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
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
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.shade900,
                                Colors.orange.shade700,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.sports_esports,
                              size: 100,
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
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Dots Indicator
                  if (widget.account.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
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
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Tier
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.account.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'K/D Ratio',
                          widget.account.kd.toString(),
                        ),
                        _buildVerticalDivider(),
                        _buildStatItem('Matches', '${widget.account.matches}+'),
                        _buildVerticalDivider(),
                        _buildStatItem('Skins', '${widget.account.skins}+'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.account.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Seller info
                  const Text(
                    'Seller',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.person,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.account.sellerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Active seller',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: Colors.orange,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.grey[800]!, width: 0.5)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'Rs ${widget.account.price}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          sellerName: widget.account.sellerName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Contact Seller',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[800]);
  }
}
