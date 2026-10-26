import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import '../widgets/logo_widget.dart';
import 'browser_screen.dart';

class TabSwitcherScreen extends StatelessWidget {
  const TabSwitcherScreen({super.key});

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
            Text('Open Tabs (${browser.tabs.length})', style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.deepOrange),
            onPressed: () {
              browser.addNewTab();
              Navigator.pop(context);
            },
            tooltip: 'New Tab',
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: browser.tabs.length,
        itemBuilder: (context, index) {
          final tab = browser.tabs[index];
          final isActive = browser.activeTabIndex == index;

          return GestureDetector(
            onTap: () {
              browser.switchTab(index);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const BrowserScreen()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E28),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive ? Colors.deepOrange : Colors.white10,
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab header bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF262633),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.public, color: Colors.white54, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            tab.title.isEmpty ? 'New Tab' : tab.title,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => browser.closeTab(index),
                          child: const Icon(Icons.close, color: Colors.white54, size: 16),
                        ),
                      ],
                    ),
                  ),
                  // Tab preview body
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.web, color: Colors.deepOrange, size: 36),
                          const SizedBox(height: 10),
                          Text(
                            tab.url,
                            style: const TextStyle(color: Colors.white60, fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Tab', style: TextStyle(color: Colors.white)),
        onPressed: () {
          browser.addNewTab();
          Navigator.pop(context);
        },
      ),
    );
  }
}
