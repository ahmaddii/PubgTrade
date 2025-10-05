import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        "type": "Deposit",
        "amount": "+ Rs 5,000",
        "date": "Oct 1",
        "status": "Completed",
      },
      {
        "type": "Purchase",
        "amount": "- Rs 2,500",
        "date": "Oct 2",
        "status": "Completed",
      },
      {
        "type": "Withdraw",
        "amount": "- Rs 3,000",
        "date": "Oct 4",
        "status": "Pending",
      },
      {
        "type": "Sale",
        "amount": "+ Rs 10,000",
        "date": "Oct 5",
        "status": "Completed",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Wallet"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade700, Colors.orange.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Balance",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Rs 12,500",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        label: const Text(
                          "Deposit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Withdraw",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Transactions Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: const [
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Transaction History
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange.withOpacity(0.2),
                        child: Icon(
                          tx["type"] == "Deposit"
                              ? Icons.arrow_downward
                              : tx["type"] == "Withdraw"
                              ? Icons.arrow_upward
                              : Icons.shopping_cart,
                          color: tx["amount"]!.startsWith("+")
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx["type"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tx["date"]!,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            tx["amount"]!,
                            style: TextStyle(
                              color: tx["amount"]!.startsWith("+")
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                tx["status"]!,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tx["status"]!,
                              style: TextStyle(
                                color: _getStatusColor(tx["status"]!),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
