import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import '../widgets/logo_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final browser = Provider.of<BrowserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121216),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A22),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ConnectWorldLogo(size: 28),
            const SizedBox(width: 10),
            const Text('Browser Settings', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Firebase Cloud Sync Section
          const Text('FIREBASE CLOUD SYNC', style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_sync, color: Colors.deepOrange),
                  title: const Text('Firebase Sync Status', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    browser.firebaseUser != null
                        ? 'Connected (${browser.firebaseUser!.uid.substring(0, 8)}...)'
                        : 'Connecting to Firebase...',
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                  ),
                  trailing: browser.isSyncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.deepOrange),
                        )
                      : IconButton(
                          icon: const Icon(Icons.sync, color: Colors.white70),
                          onPressed: () => browser.syncCloudData(),
                          tooltip: 'Sync Now',
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('APPEARANCE & PERFORMANCE', style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Data Saver Mode', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Compress pages and save mobile data', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  value: browser.dataSaverEnabled,
                  activeThumbColor: Colors.deepOrange,
                  onChanged: (val) {
                    browser.toggleDataSaver();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('PRIVACY & SECURITY', style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Block Ads & Trackers', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Brave Shields aggressive blocking', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  value: browser.shieldSettings.adsBlockedEnabled,
                  activeThumbColor: Colors.deepOrange,
                  onChanged: (val) {
                    browser.updateShieldSettings(ads: val);
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                SwitchListTile(
                  title: const Text('Block Third-Party Cookies', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Prevent cross-site tracking', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  value: browser.shieldSettings.cookieBlockerEnabled,
                  activeThumbColor: Colors.deepOrange,
                  onChanged: (val) {
                    browser.updateShieldSettings(cookies: val);
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                SwitchListTile(
                  title: const Text('HTTPS Everywhere', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Upgrade connections to secure HTTPS', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  value: browser.shieldSettings.httpsUpgradeEnabled,
                  activeThumbColor: Colors.deepOrange,
                  onChanged: (val) {
                    browser.updateShieldSettings(https: val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('GENERAL', style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Search Engine', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    browser.searchEngineUrl.contains('duckduckgo') ? 'DuckDuckGo (Private)' : 'Google',
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF1E1E28),
                        title: const Text('Select Search Engine', style: TextStyle(color: Colors.white)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('DuckDuckGo', style: TextStyle(color: Colors.white)),
                              onTap: () {
                                browser.setSearchEngine('https://duckduckgo.com/?q=');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Google', style: TextStyle(color: Colors.white)),
                              onTap: () {
                                browser.setSearchEngine('https://www.google.com/search?q=');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  title: const Text('Clear Browsing Data', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Cache, history, cookies and site data', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  trailing: const Icon(Icons.delete_outline, color: Colors.deepOrange),
                  onTap: () {
                    browser.clearHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Browsing data cleared successfully')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('ABOUT', style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: const Column(
              children: [
                ListTile(
                  title: Text('ConnectWorld Browser', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Version 1.0.0 (Production Build + Real-World Features)', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  trailing: ConnectWorldLogo(size: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
