import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import '../widgets/logo_widget.dart';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({super.key});

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showAddPasswordDialog(BuildContext context) {
    final browser = Provider.of<BrowserProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E28),
        title: const Text('Add Saved Password', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _domainController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Website Domain (e.g. github.com)', labelStyle: TextStyle(color: Colors.white60)),
            ),
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Username / Email', labelStyle: TextStyle(color: Colors.white60)),
            ),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.white60)),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (_domainController.text.isNotEmpty && _usernameController.text.isNotEmpty) {
                browser.addPassword(_domainController.text, _usernameController.text, _passwordController.text);
                _domainController.clear();
                _usernameController.clear();
                _passwordController.clear();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

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
            const Text('Password Manager', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.deepOrange),
            onPressed: () => _showAddPasswordDialog(context),
            tooltip: 'Add Password',
          ),
        ],
      ),
      body: browser.passwords.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, color: Colors.white54, size: 64),
                  SizedBox(height: 16),
                  Text('No saved passwords', style: TextStyle(color: Colors.white54, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: browser.passwords.length,
              itemBuilder: (context, index) {
                final item = browser.passwords[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E28),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.key, color: Colors.deepOrange),
                    title: Text(item.domain, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.username}\n${item.password}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white54),
                      onPressed: () => browser.removePassword(item.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
