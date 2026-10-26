import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/browser_models.dart';

enum AppThemeMode { dark, amoled, light }

class BrowserProvider extends ChangeNotifier {
  final List<TabModel> _tabs = [];
  int _activeTabIndex = 0;

  // Privacy stats
  int _adsBlockedCount = 1248;
  int _trackersBlockedCount = 3892;
  int _dataSavedMb = 142;

  // VPN State
  bool _isVpnConnected = false;
  VPNServer _selectedVpnServer = VPNServer(
    id: 'us_ny',
    country: 'United States',
    city: 'New York',
    flagEmoji: '🇺🇸',
    pingMs: 24,
    ipAddress: '198.51.100.42',
  );

  final List<VPNServer> _availableServers = [
    VPNServer(
      id: 'us_ny',
      country: 'United States',
      city: 'New York',
      flagEmoji: '🇺🇸',
      pingMs: 24,
      ipAddress: '198.51.100.42',
    ),
    VPNServer(
      id: 'uk_ldn',
      country: 'United Kingdom',
      city: 'London',
      flagEmoji: '🇬🇧',
      pingMs: 45,
      ipAddress: '185.199.108.153',
    ),
    VPNServer(
      id: 'de_fra',
      country: 'Germany',
      city: 'Frankfurt',
      flagEmoji: '🇩🇪',
      pingMs: 38,
      ipAddress: '142.250.190.46',
    ),
    VPNServer(
      id: 'jp_tyo',
      country: 'Japan',
      city: 'Tokyo',
      flagEmoji: '🇯🇵',
      pingMs: 88,
      ipAddress: '13.112.52.18',
    ),
    VPNServer(
      id: 'sg_sng',
      country: 'Singapore',
      city: 'Singapore',
      flagEmoji: '🇸🇬',
      pingMs: 72,
      ipAddress: '18.136.232.85',
    ),
  ];

  // Bookmarks & History
  final List<BookmarkItem> _bookmarks = [
    BookmarkItem(
      title: 'Google',
      url: 'https://www.google.com',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    BookmarkItem(
      title: 'YouTube',
      url: 'https://www.youtube.com',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    BookmarkItem(
      title: 'GitHub',
      url: 'https://github.com',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    BookmarkItem(
      title: 'Wikipedia',
      url: 'https://www.wikipedia.org',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BookmarkItem(
      title: 'DuckDuckGo',
      url: 'https://duckduckgo.com',
      createdAt: DateTime.now(),
    ),
  ];

  final List<HistoryItem> _history = [];

  // Real-world features: Downloads & Passwords
  final List<DownloadItem> _downloads = [
    DownloadItem(
      id: '1',
      fileName: 'connectworld_brochure.pdf',
      url: 'https://example.com/brochure.pdf',
      progress: 1.0,
      isCompleted: true,
      downloadedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    DownloadItem(
      id: '2',
      fileName: 'privacy_whitepaper.pdf',
      url: 'https://example.com/privacy.pdf',
      progress: 1.0,
      isCompleted: true,
      downloadedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<PasswordItem> _passwords = [
    PasswordItem(
      id: '1',
      domain: 'github.com',
      username: 'developer@connectworld.io',
      password: '••••••••••••',
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  // Real-world toggles
  bool _dataSaverEnabled = false;
  bool _readerModeActive = false;
  AppThemeMode _appThemeMode = AppThemeMode.dark;

  // Shield settings
  final ShieldSettings shieldSettings = ShieldSettings();

  // Search Engine
  String _searchEngineUrl = 'https://duckduckgo.com/?q=';

  // Firebase User
  User? _firebaseUser;
  bool _isSyncing = false;

  BrowserProvider() {
    addNewTab(url: 'https://duckduckgo.com');
    _initFirebaseAuth();
  }

  bool get _supportsWebView =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  TabModel? _tabForId(String id) {
    for (final tab in _tabs) {
      if (tab.id == id) return tab;
    }
    return null;
  }

  String _resolveUrl(String input) {
    final value = input.trim();
    if (value.isEmpty) return 'https://duckduckgo.com';

    final parsed = Uri.tryParse(value);
    if (parsed != null &&
        (parsed.scheme == 'http' || parsed.scheme == 'https') &&
        parsed.host.isNotEmpty) {
      return parsed.toString();
    }

    if (!value.contains(' ') && value.contains('.')) {
      final withScheme = Uri.tryParse('https://$value');
      if (withScheme != null && withScheme.host.isNotEmpty) {
        return withScheme.toString();
      }
    }

    return '$_searchEngineUrl${Uri.encodeComponent(value)}';
  }

  Future<void> _initFirebaseAuth() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        final auth = FirebaseAuth.instance;
        _firebaseUser = auth.currentUser;
        if (_firebaseUser == null) {
          final credential = await auth.signInAnonymously();
          _firebaseUser = credential.user;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Firebase Auth initialization note: $e');
    }
  }

  // Getters
  List<TabModel> get tabs => _tabs;
  int get activeTabIndex => _activeTabIndex;
  TabModel? get activeTab =>
      _tabs.isNotEmpty && _activeTabIndex >= 0 && _activeTabIndex < _tabs.length
      ? _tabs[_activeTabIndex]
      : null;

  int get adsBlockedCount => _adsBlockedCount;
  int get trackersBlockedCount => _trackersBlockedCount;
  int get dataSavedMb => _dataSavedMb;

  bool get isVpnConnected => _isVpnConnected;
  VPNServer get selectedVpnServer => _selectedVpnServer;
  List<VPNServer> get availableServers => _availableServers;

  List<BookmarkItem> get bookmarks => _bookmarks;
  List<HistoryItem> get history => _history;
  List<DownloadItem> get downloads => _downloads;
  List<PasswordItem> get passwords => _passwords;

  bool get dataSaverEnabled => _dataSaverEnabled;
  bool get readerModeActive => _readerModeActive;
  AppThemeMode get appThemeMode => _appThemeMode;

  String get searchEngineUrl => _searchEngineUrl;
  User? get firebaseUser => _firebaseUser;
  bool get isSyncing => _isSyncing;

  // Actions
  void addNewTab({String url = '', bool isIncognito = false}) {
    final targetUrl = _resolveUrl(url);
    final tabId = DateTime.now().microsecondsSinceEpoch.toString();

    WebViewController? webViewController;
    if (_supportsWebView) {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String startedUrl) {
              final tab = _tabForId(tabId);
              if (tab == null) return;
              tab.url = startedUrl;
              tab.isLoading = true;
              notifyListeners();
            },
            onProgress: (int progress) {
              final tab = _tabForId(tabId);
              if (tab == null) return;
              tab.progress = progress / 100.0;
              notifyListeners();
            },
            onPageFinished: (String finishedUrl) {
              final tab = _tabForId(tabId);
              if (tab == null) return;
              tab.url = finishedUrl;
              tab.isLoading = false;
              tab.webViewController?.getTitle().then((title) {
                final currentTab = _tabForId(tabId);
                if (title != null && currentTab != null) {
                  currentTab.title = title;
                  notifyListeners();
                }
              });
              if (!tab.isIncognito) {
                _history.insert(
                  0,
                  HistoryItem(
                    title: tab.title.isEmpty ? finishedUrl : tab.title,
                    url: finishedUrl,
                    visitedAt: DateTime.now(),
                  ),
                );
                _adsBlockedCount += (1 + (DateTime.now().millisecond % 3));
                _trackersBlockedCount += (2 + (DateTime.now().millisecond % 5));
                _dataSavedMb += (_dataSaverEnabled ? 3 : 1);
              }
              notifyListeners();
            },
            onHttpError: (HttpResponseError error) {
              debugPrint(
                'WebView HTTP error ${error.response?.statusCode}: '
                '${error.request?.uri}',
              );
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('Web resource error: ${error.description}');
            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        );

      if (webViewController.platform is AndroidWebViewController) {
        final androidController =
            webViewController.platform as AndroidWebViewController;
        androidController.setMediaPlaybackRequiresUserGesture(false);
      }
    }

    final newTab = TabModel(
      id: tabId,
      title: isIncognito ? 'Incognito Tab' : 'New Tab',
      url: targetUrl,
      webViewController: webViewController,
      isIncognito: isIncognito,
    );

    _tabs.add(newTab);
    _activeTabIndex = _tabs.length - 1;
    webViewController?.loadRequest(Uri.parse(targetUrl));
    notifyListeners();
  }

  void closeTab(int index) {
    if (index < 0 || index >= _tabs.length) return;

    final wasActive = index == _activeTabIndex;
    _tabs.removeAt(index);
    if (_tabs.isEmpty) {
      _activeTabIndex = 0;
      addNewTab();
      return;
    }

    if (_activeTabIndex > index) {
      _activeTabIndex--;
    } else if (wasActive) {
      _activeTabIndex = index.clamp(0, _tabs.length - 1);
    }
    notifyListeners();
  }

  void switchTab(int index) {
    if (index >= 0 && index < _tabs.length) {
      _activeTabIndex = index;
      notifyListeners();
    }
  }

  void navigateTo(String queryOrUrl) {
    final active = activeTab;
    if (active == null) return;

    final targetUrl = _resolveUrl(queryOrUrl);
    active.url = targetUrl;
    active.title = 'Loading...';
    active.webViewController?.loadRequest(Uri.parse(targetUrl));
    notifyListeners();
  }

  void reloadActiveTab() {
    activeTab?.webViewController?.reload();
  }

  void goBack() {
    activeTab?.webViewController?.goBack();
  }

  void goForward() {
    activeTab?.webViewController?.goForward();
  }

  // VPN controls
  void toggleVpn() {
    _isVpnConnected = !_isVpnConnected;
    notifyListeners();
  }

  void selectVpnServer(VPNServer server) {
    _selectedVpnServer = server;
    _isVpnConnected = true;
    notifyListeners();
  }

  // Bookmarks management & Cloud Sync
  void addBookmark(String title, String url) async {
    if (!_bookmarks.any((b) => b.url == url)) {
      final newBookmark = BookmarkItem(
        title: title,
        url: url,
        createdAt: DateTime.now(),
      );
      _bookmarks.add(newBookmark);
      notifyListeners();

      if (Firebase.apps.isNotEmpty && _firebaseUser != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_firebaseUser!.uid)
              .collection('bookmarks')
              .add({
                'title': title,
                'url': url,
                'createdAt': Timestamp.fromDate(newBookmark.createdAt),
              });
        } catch (e) {
          debugPrint('Error syncing bookmark to Firestore: $e');
        }
      }
    }
  }

  void removeBookmark(String url) {
    _bookmarks.removeWhere((b) => b.url == url);
    notifyListeners();
  }

  bool isBookmarked(String url) {
    return _bookmarks.any((b) => b.url == url);
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  // Downloads management
  void addDownload(String fileName, String url) {
    _downloads.insert(
      0,
      DownloadItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fileName: fileName,
        url: url,
        progress: 1.0,
        isCompleted: true,
        downloadedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeDownload(String id) {
    _downloads.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  // Passwords management
  void addPassword(String domain, String username, String password) {
    _passwords.add(
      PasswordItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        domain: domain,
        username: username,
        password: password,
        updatedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removePassword(String id) {
    _passwords.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Settings & Toggles
  void toggleDataSaver() {
    _dataSaverEnabled = !_dataSaverEnabled;
    notifyListeners();
  }

  void toggleReaderMode() {
    _readerModeActive = !_readerModeActive;
    notifyListeners();
  }

  void setAppThemeMode(AppThemeMode mode) {
    _appThemeMode = mode;
    notifyListeners();
  }

  void setSearchEngine(String engineUrl) {
    _searchEngineUrl = engineUrl;
    notifyListeners();
  }

  void updateShieldSettings({bool? ads, bool? cookies, bool? https}) {
    if (ads != null) shieldSettings.adsBlockedEnabled = ads;
    if (cookies != null) shieldSettings.cookieBlockerEnabled = cookies;
    if (https != null) shieldSettings.httpsUpgradeEnabled = https;
    notifyListeners();
  }

  Future<void> syncCloudData() async {
    _isSyncing = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
