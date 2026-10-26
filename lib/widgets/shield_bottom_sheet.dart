import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';

class ShieldBottomSheet extends StatelessWidget {
  const ShieldBottomSheet({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield, color: Colors.deepOrange, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Brave Shields Up',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('PROTECTED', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF262633),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShieldStat('Ads Blocked', '${browser.adsBlockedCount}'),
                _buildShieldStat('Trackers Blocked', '${browser.trackersBlockedCount}'),
                _buildShieldStat('Data Saved', '${browser.dataSavedMb} MB'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Block Ads & Trackers', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Prevent intrusive scripts and popups', style: TextStyle(color: Colors.white60, fontSize: 12)),
            value: browser.shieldSettings.adsBlockedEnabled,
            activeThumbColor: Colors.deepOrange,
            onChanged: (val) {
              browser.updateShieldSettings(ads: val);
            },
          ),
          SwitchListTile(
            title: const Text('HTTPS Upgrades', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Automatically use secure connections', style: TextStyle(color: Colors.white60, fontSize: 12)),
            value: browser.shieldSettings.httpsUpgradeEnabled,
            activeThumbColor: Colors.deepOrange,
            onChanged: (val) {
              browser.updateShieldSettings(https: val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShieldStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}
