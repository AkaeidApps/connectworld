import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import '../screens/bookmarks_history_screen.dart';
import '../screens/downloads_screen.dart';
import '../screens/passwords_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/vpn_screen.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final browser = Provider.of<BrowserProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A22),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuItem(context, Icons.refresh, 'Reload', () {
                Navigator.pop(context);
                browser.reloadActiveTab();
              }),
              _buildMenuItem(context, Icons.bookmark_add, 'Bookmark', () {
                Navigator.pop(context);
                final active = browser.activeTab;
                if (active != null) {
                  browser.addBookmark(active.title, active.url);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to bookmarks')),
                  );
                }
              }),
              _buildMenuItem(context, Icons.vpn_lock, 'VPN', () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const VpnScreen()));
              }),
              _buildMenuItem(context, Icons.history, 'History', () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BookmarksHistoryScreen()));
              }),
            ],
          ),
          const Divider(color: Colors.white12, height: 24),
          ListTile(
            leading: const Icon(Icons.add_box_outlined, color: Colors.white),
            title: const Text('New Tab', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              browser.addNewTab();
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility_off, color: Colors.deepOrange),
            title: const Text('New Incognito Tab', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              browser.addNewTab(isIncognito: true);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download, color: Colors.white),
            title: const Text('Downloads', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DownloadsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.key, color: Colors.white),
            title: const Text('Password Manager', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PasswordsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.white),
            title: Text(browser.readerModeActive ? 'Disable Reader Mode' : 'Enable Reader Mode', style: const TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              browser.toggleReaderMode();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(browser.readerModeActive ? 'Reader Mode Enabled' : 'Reader Mode Disabled')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF262633),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
