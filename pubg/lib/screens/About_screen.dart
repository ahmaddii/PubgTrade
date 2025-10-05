import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.videogame_asset,
                color: Colors.black,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),

            // App Name
            const Text(
              "PubgTrade",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Version
            const Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              "PubgTrade is a secure marketplace for gamers to buy and sell gaming accounts. "
              "Easily list your PUBG, Free Fire, or other game accounts, manage your sales, "
              "and track your wallet all in one place.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // Developer Info
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.orange),
                title: const Text(
                  "Developed by",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Pulsar X",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Links
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.orange),
                title: const Text(
                  "Privacy Policy",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white70,
                ),
                onTap: () {
                  // TODO: Open Privacy Policy page / link
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
                leading: const Icon(Icons.article, color: Colors.orange),
                title: const Text(
                  "Terms & Conditions",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white70,
                ),
                onTap: () {
                  // TODO: Open Terms & Conditions page / link
                },
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "© 2025 PubgTrade. All rights reserved.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
