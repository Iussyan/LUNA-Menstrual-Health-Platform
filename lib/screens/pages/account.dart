import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user from Supabase
    final user = Supabase.instance.client.auth.currentUser;
    // 1. Get the current user and their photo URL
    final String? avatarUrl = user?.userMetadata?['avatar_url'];

    return Scaffold(
      appBar: AppBar(title: const Text("My Account"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.pinkAccent.withValues(
                  alpha: 0.1,
                ), // Soft background for the fallback
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : null, // Only use NetworkImage if the URL exists
                child: avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.pinkAccent,
                      )
                    : null, // Show icon only if there is no image
              ),
            ),
            const SizedBox(height: 15),
            Text(
              user?.userMetadata?['full_name'] ?? "Luna User",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? "email@example.com",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 2. Settings Section
            _buildSettingsItem(
              icon: Icons.edit_note,
              title: "Edit Profile",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.notifications_none,
              title: "Notifications",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.lock_outline,
              title: "Privacy & Security",
              onTap: () {},
            ),

            const Divider(height: 40),

            // 3. Danger Zone
            _buildSettingsItem(
              icon: Icons.logout,
              title: "Logout",
              textColor: Colors.red,
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for setting rows to keep code clean
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.pinkAccent),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
