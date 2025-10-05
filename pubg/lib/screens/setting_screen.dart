import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // Profile Section
          ListTile(
            leading: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, color: Colors.black, size: 30),
            ),
            title: const Text(
              "Ahmad Malik",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "ahmad@gmail.com",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Edit", style: TextStyle(color: Colors.black)),
              onPressed: () {
                // TODO: Navigate to Edit Profile screen
              },
            ),
          ),

          const Divider(color: Colors.grey),

          // Account Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Account",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          _buildSettingItem(Icons.lock, "Change Password", onTap: () {}),
          _buildSettingItem(Icons.security, "Privacy & Security", onTap: () {}),
          _buildSettingItem(Icons.language, "Language", onTap: () {}),
          _buildSettingItem(Icons.notifications, "Notifications", onTap: () {}),

          const Divider(color: Colors.grey),

          // App Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "App",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          _buildSettingItem(Icons.info, "About App", onTap: () {}),
          _buildSettingItem(Icons.help, "Help & Support", onTap: () {}),

          const Divider(color: Colors.grey),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // TODO: Add logout functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
