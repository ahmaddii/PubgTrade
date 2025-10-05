import 'package:flutter/material.dart';
import 'package:pubg/screens/upload_account_screen.dart';

class MyAccountsScreen extends StatelessWidget {
  const MyAccountsScreen({Key? key}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case "Available":
        return Colors.green;
      case "Sold":
        return Colors.red;
      case "Pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Temporary dummy data (later from Supabase)
    final accounts = [
      {
        "game": "PUBG Mobile",
        "rank": "Ace",
        "skins": "25 Skins",
        "price": "Rs 10,000",
        "status": "Available",
      },
      {
        "game": "Free Fire",
        "rank": "Diamond",
        "skins": "12 Skins",
        "price": "Rs 5,500",
        "status": "Sold",
      },
      {
        "game": "PUBG Mobile",
        "rank": "Conqueror",
        "skins": "40 Skins",
        "price": "Rs 20,000",
        "status": "Pending",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Accounts"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: const Icon(
                          Icons.videogame_asset,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "${account["game"]} • ${account["rank"]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == "edit") {
                            // TODO: Go to edit screen
                          } else if (value == "delete") {
                            // TODO: Delete confirmation
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: "delete",
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Middle Info + Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        account["skins"]!,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            account["status"]!,
                          ).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(account["status"]!),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          account["status"]!,
                          style: TextStyle(
                            color: _getStatusColor(account["status"]!),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Bottom Price
                  Text(
                    account["price"]!,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // FAB to add a new account
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UploadAccountScreen(),
            ),
          );
        },
      ),
    );
  }
}
