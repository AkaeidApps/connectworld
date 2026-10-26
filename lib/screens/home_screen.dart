import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import '../widgets/logo_widget.dart';
import 'vpn_screen.dart';
import 'settings_screen.dart';
import 'bookmarks_history_screen.dart';
import 'browser_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _homeSearchController = TextEditingController();

  void _performSearch(BuildContext context, String query) {
    if (query.trim().isNotEmpty) {
      final browser = Provider.of<BrowserProvider>(context, listen: false);
      browser.addNewTab(url: query.trim());
      _homeSearchController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BrowserScreen()),
      );
    }
  }

  @override
  void dispose() {
    _homeSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final browser = Provider.of<BrowserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121216),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A22),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ConnectWorldLogo(size: 36),
            const SizedBox(width: 12),
            const Text(
              'ConnectWorld',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          // VPN Badge / Button
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VpnScreen()));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: browser.isVpnConnected ? Colors.green.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: browser.isVpnConnected ? Colors.green : Colors.grey,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    browser.isVpnConnected ? Icons.vpn_lock : Icons.vpn_key_off,
                    size: 14,
                    color: browser.isVpnConnected ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    browser.isVpnConnected ? 'VPN ON' : 'VPN OFF',
                    style: TextStyle(
                      color: browser.isVpnConnected ? Colors.green : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Stats Banner (Brave Style)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF232332), Color(0xFF1B1B24)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PRIVACY SHIELD STATS',
                        style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('PRO ACTIVE', style: TextStyle(color: Colors.deepOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Ads & Trackers', '${browser.adsBlockedCount + browser.trackersBlockedCount}', Icons.security),
                      _buildStatItem('Data Saved', '${browser.dataSavedMb} MB', Icons.data_usage),
                      _buildStatItem('HTTPS Upgraded', '100%', Icons.lock),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search Bar / Omnibox with Suffix Search Button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E28),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _homeSearchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search DuckDuckGo or enter web address',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54, size: 20),
                        onPressed: () => _homeSearchController.clear(),
                        tooltip: 'Clear',
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        decoration: const BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          onPressed: () => _performSearch(context, _homeSearchController.text),
                          tooltip: 'Search / Go',
                        ),
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onSubmitted: (value) => _performSearch(context, value),
              ),
            ),
            const SizedBox(height: 28),

            // Quick Shortcuts Grid
            const Text(
              'Quick Shortcuts',
              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildShortcutItem(context, 'Google', 'https://www.google.com', Icons.g_mobiledata, Colors.blue),
                _buildShortcutItem(context, 'YouTube', 'https://www.youtube.com', Icons.play_arrow, Colors.red),
                _buildShortcutItem(context, 'GitHub', 'https://github.com', Icons.code, Colors.purple),
                _buildShortcutItem(context, 'Wikipedia', 'https://www.wikipedia.org', Icons.book, Colors.white),
                _buildShortcutItem(context, 'Reddit', 'https://www.reddit.com', Icons.forum, Colors.deepOrange),
                _buildShortcutItem(context, 'DuckDuckGo', 'https://duckduckgo.com', Icons.search, Colors.orange),
                _buildShortcutItem(context, 'X / Twitter', 'https://x.com', Icons.close, Colors.blueGrey),
                _buildShortcutItem(context, 'Bookmarks', '', Icons.bookmark, Colors.amber, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const BookmarksHistoryScreen()));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildShortcutItem(BuildContext context, String title, String url, IconData icon, Color color, {VoidCallback? onTap}) {
    final browser = Provider.of<BrowserProvider>(context, listen: false);
    return GestureDetector(
      onTap: onTap ?? () {
        browser.addNewTab(url: url);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BrowserScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
