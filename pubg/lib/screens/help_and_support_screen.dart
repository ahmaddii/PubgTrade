import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            "How can we help you?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Find answers to common questions or reach out to us.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),

          // FAQ Section
          _buildSectionTitle("Frequently Asked Questions"),
          _buildFaqItem(
            "How to buy an account?",
            "Browse available accounts, tap to view details, and follow purchase steps.",
          ),
          _buildFaqItem(
            "How to sell an account?",
            "Go to Upload section, fill in account details, and list it for sale.",
          ),
          _buildFaqItem(
            "How to withdraw money?",
            "Open Wallet, select Withdraw, and enter your payment details.",
          ),
          _buildFaqItem(
            "Is my data safe?",
            "Yes! We use secure servers and encryption to protect your data.",
          ),

          const SizedBox(height: 20),

          // Contact Section
          _buildSectionTitle("Need More Help?"),
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.orange),
              title: const Text(
                "Contact Support",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "support@pubgtrade.com",
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
              onTap: () {
                // TODO: Open email support
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.chat, color: Colors.orange),
              title: const Text(
                "Live Chat",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Chat with our support team",
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
              onTap: () {
                // TODO: Open live chat screen
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.call, color: Colors.orange),
              title: const Text(
                "Call Us",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "+92 300 1234567",
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
              onTap: () {
                // TODO: Dial support number
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      collapsedIconColor: Colors.white,
      iconColor: Colors.orange,
      title: Text(
        question,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            answer,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
