import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import '../widgets/logo_widget.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

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
            const Text('Downloads Manager', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: browser.downloads.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_done, color: Colors.white54, size: 64),
                  SizedBox(height: 16),
                  Text('No downloads yet', style: TextStyle(color: Colors.white54, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: browser.downloads.length,
              itemBuilder: (context, index) {
                final item = browser.downloads[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E28),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.insert_drive_file, color: Colors.deepOrange, size: 22),
                    ),
                    title: Text(item.fileName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(item.url, style: const TextStyle(color: Colors.white60, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white54),
                      onPressed: () => browser.removeDownload(item.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
