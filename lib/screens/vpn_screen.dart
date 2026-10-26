import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import '../widgets/logo_widget.dart';

class VpnScreen extends StatelessWidget {
  const VpnScreen({super.key});

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
            const Text('ConnectWorld VPN', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // VPN Connection Orb / Button
            GestureDetector(
              onTap: () => browser.toggleVpn(),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: browser.isVpnConnected
                        ? [Colors.green.shade700, Colors.green.shade400]
                        : [Colors.grey.shade800, Colors.grey.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (browser.isVpnConnected ? Colors.green : Colors.black).withValues(alpha: 0.5),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      browser.isVpnConnected ? Icons.lock : Icons.lock_open,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      browser.isVpnConnected ? 'CONNECTED' : 'DISCONNECTED',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Connection Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E28),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Selected Server', style: TextStyle(color: Colors.white60)),
                      Row(
                        children: [
                          Text(browser.selectedVpnServer.flagEmoji, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            '${browser.selectedVpnServer.country} (${browser.selectedVpnServer.city})',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Virtual IP', style: TextStyle(color: Colors.white60)),
                      Text(browser.isVpnConnected ? browser.selectedVpnServer.ipAddress : '---.---.---.--', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Encryption', style: TextStyle(color: Colors.white60)),
                      const Text('AES-256 WireGuard®', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ping', style: TextStyle(color: Colors.white60)),
                      Text('${browser.selectedVpnServer.pingMs} ms', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Server List Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Server Locations',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),

            // Servers ListView
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: browser.availableServers.length,
              itemBuilder: (context, index) {
                final server = browser.availableServers[index];
                final isSelected = browser.selectedVpnServer.id == server.id;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E28),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.white10,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Text(server.flagEmoji, style: const TextStyle(fontSize: 28)),
                    title: Text(server.country, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('${server.city} • ${server.pingMs} ms', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    trailing: Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? Colors.green : Colors.white54,
                    ),
                    onTap: () {
                      browser.selectVpnServer(server);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
