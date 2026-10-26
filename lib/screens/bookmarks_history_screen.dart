import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import '../widgets/logo_widget.dart';
import 'browser_screen.dart';

class BookmarksHistoryScreen extends StatelessWidget {
  const BookmarksHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final browser = Provider.of<BrowserProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF121216),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A22),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ConnectWorldLogo(size: 28),
              const SizedBox(width: 10),
              const Text('Bookmarks & History', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Colors.deepOrange,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: 'Bookmarks'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Bookmarks List
            browser.bookmarks.isEmpty
                ? const Center(child: Text('No bookmarks saved', style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: browser.bookmarks.length,
                    itemBuilder: (context, index) {
                      final item = browser.bookmarks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E28),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.bookmark, color: Colors.deepOrange),
                          title: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(item.url, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.white54),
                            onPressed: () => browser.removeBookmark(item.url),
                          ),
                          onTap: () {
                            browser.addNewTab(url: item.url);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BrowserScreen()));
                          },
                        ),
                      );
                    },
                  ),

            // History List
            Column(
              children: [
                if (browser.history.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete_sweep, color: Colors.deepOrange, size: 18),
                        label: const Text('Clear History', style: TextStyle(color: Colors.deepOrange)),
                        onPressed: () => browser.clearHistory(),
                      ),
                    ),
                  ),
                Expanded(
                  child: browser.history.isEmpty
                      ? const Center(child: Text('No browsing history', style: TextStyle(color: Colors.white54)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: browser.history.length,
                          itemBuilder: (context, index) {
                            final item = browser.history[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E28),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.history, color: Colors.white54),
                                title: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                subtitle: Text(item.url, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                                onTap: () {
                                  browser.addNewTab(url: item.url);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BrowserScreen()));
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
