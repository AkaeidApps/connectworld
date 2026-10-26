import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/browser_provider.dart';
import '../widgets/logo_widget.dart';
import '../widgets/menu_bottom_sheet.dart';
import '../widgets/shield_bottom_sheet.dart';
import 'tab_switcher_screen.dart';
import 'vpn_screen.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isEditingUrl = false;

  @override
  Widget build(BuildContext context) {
    final browser = Provider.of<BrowserProvider>(context);
    final activeTab = browser.activeTab;

    if (activeTab != null && !_isEditingUrl) {
      _urlController.text = activeTab.url;
    }

    final bool isMobilePlatform = !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

    return Scaffold(
      backgroundColor: const Color(0xFF121216),
      body: SafeArea(
        child: Column(
          children: [
            // Top URL & Toolbar with Professional Logo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: const Color(0xFF1A1A22),
              child: Row(
                children: [
                  const ConnectWorldLogo(size: 32),
                  const SizedBox(width: 8),
                  // Shield / Privacy Button
                  IconButton(
                    icon: const Icon(Icons.shield, color: Colors.deepOrange, size: 20),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF1A1A22),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => const ShieldBottomSheet(),
                      );
                    },
                    tooltip: 'Brave Shields',
                  ),
                  // URL / Omnibox Input Field with Suffix Search/Go Button
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF262633),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: TextField(
                        controller: _urlController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        onTap: () {
                          setState(() {
                            _isEditingUrl = true;
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _isEditingUrl = false;
                          });
                          browser.navigateTo(value);
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Colors.green, size: 16),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (activeTab != null && activeTab.isLoading)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.deepOrange),
                                  ),
                                )
                              else
                                IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.white54, size: 16),
                                  onPressed: () => _urlController.clear(),
                                  tooltip: 'Clear',
                                ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_rounded, color: Colors.deepOrange, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _isEditingUrl = false;
                                  });
                                  browser.navigateTo(_urlController.text);
                                },
                                tooltip: 'Go / Search',
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // VPN Indicator Button
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VpnScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: browser.isVpnConnected ? Colors.green.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: browser.isVpnConnected ? Colors.green : Colors.grey),
                      ),
                      child: Icon(
                        browser.isVpnConnected ? Icons.vpn_lock : Icons.vpn_key_off,
                        size: 16,
                        color: browser.isVpnConnected ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading Progress Bar
            if (activeTab != null && activeTab.isLoading && activeTab.progress < 1.0)
              LinearProgressIndicator(
                value: activeTab.progress,
                backgroundColor: Colors.transparent,
                color: Colors.deepOrange,
                minHeight: 2,
              ),

            // WebView Body (Platform safe: real WebView on Mobile, interactive preview on Desktop/Web)
            Expanded(
              child: isMobilePlatform && activeTab != null && activeTab.webViewController != null
                  ? WebViewWidget(controller: activeTab.webViewController!)
                  : Container(
                      color: const Color(0xFF121216),
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.public, color: Colors.deepOrange, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            activeTab?.title.isEmpty ?? true ? 'ConnectWorld Secure Browser' : activeTab!.title,
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E28),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Text(
                              activeTab?.url ?? 'https://duckduckgo.com',
                              style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            '🛡️ Brave Shields & VPN are active.\nMobile WebView runs on Android/iOS devices.\nDesktop/Web runs in secure preview mode.',
                            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),

            // Bottom Navigation Toolbar
            Container(
              color: const Color(0xFF1A1A22),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white70),
                    onPressed: () => browser.goBack(),
                    tooltip: 'Back',
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white70),
                    onPressed: () => browser.goForward(),
                    tooltip: 'Forward',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined, color: Colors.white70),
                    onPressed: () => browser.addNewTab(),
                    tooltip: 'New Tab',
                  ),
                  // Tabs Switcher Counter Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TabSwitcherScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70, width: 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${browser.tabs.length}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white70),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF1A1A22),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => const MenuBottomSheet(),
                      );
                    },
                    tooltip: 'Menu',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
