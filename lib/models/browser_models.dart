import 'package:webview_flutter/webview_flutter.dart';

class TabModel {
  final String id;
  String title;
  String url;
  WebViewController? webViewController;
  bool isIncognito;
  double progress;
  bool isLoading;

  TabModel({
    required this.id,
    this.title = 'New Tab',
    this.url = '',
    this.webViewController,
    this.isIncognito = false,
    this.progress = 0.0,
    this.isLoading = false,
  });
}

class VPNServer {
  final String id;
  final String country;
  final String city;
  final String flagEmoji;
  final int pingMs;
  final String ipAddress;

  VPNServer({
    required this.id,
    required this.country,
    required this.city,
    required this.flagEmoji,
    required this.pingMs,
    required this.ipAddress,
  });
}

class BookmarkItem {
  final String title;
  final String url;
  final DateTime createdAt;

  BookmarkItem({
    required this.title,
    required this.url,
    required this.createdAt,
  });
}

class HistoryItem {
  final String title;
  final String url;
  final DateTime visitedAt;

  HistoryItem({
    required this.title,
    required this.url,
    required this.visitedAt,
  });
}

class DownloadItem {
  final String id;
  final String fileName;
  final String url;
  final double progress;
  final bool isCompleted;
  final DateTime downloadedAt;

  DownloadItem({
    required this.id,
    required this.fileName,
    required this.url,
    required this.progress,
    required this.isCompleted,
    required this.downloadedAt,
  });
}

class PasswordItem {
  final String id;
  final String domain;
  final String username;
  final String password;
  final DateTime updatedAt;

  PasswordItem({
    required this.id,
    required this.domain,
    required this.username,
    required this.password,
    required this.updatedAt,
  });
}

class ShieldSettings {
  bool adsBlockedEnabled;
  bool trackersBlockedEnabled;
  bool cookieBlockerEnabled;
  bool httpsUpgradeEnabled;
  bool scriptBlockerEnabled;

  ShieldSettings({
    this.adsBlockedEnabled = true,
    this.trackersBlockedEnabled = true,
    this.cookieBlockerEnabled = true,
    this.httpsUpgradeEnabled = true,
    this.scriptBlockerEnabled = false,
  });
}
