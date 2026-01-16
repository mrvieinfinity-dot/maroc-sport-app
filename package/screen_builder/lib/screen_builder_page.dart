import 'package:flutter/material.dart';
import 'bootstrap.dart';
import 'engine/page_engine.dart';
import 'models/page_model.dart';
import 'navigation/navigation_adapter.dart';
import 'dart:convert';

/// Custom NavigationAdapter for ScreenBuilderPage
class _ScreenBuilderNavigationAdapter extends NavigationAdapter {
  final Function(String) onNavigate;

  _ScreenBuilderNavigationAdapter(this.onNavigate);

  @override
  void navigate(String route) {
    onNavigate(route);
  }
}

/// Main widget for Screen Builder CMS
class ScreenBuilderPage extends StatefulWidget {
  const ScreenBuilderPage({super.key});

  @override
  State<ScreenBuilderPage> createState() => _ScreenBuilderPageState();
}

class _ScreenBuilderPageState extends State<ScreenBuilderPage> {
  String? _currentPage;
  Map<String, dynamic>? _navigation;
  PreferredSizeWidget? _currentAppBar;
  Widget? _currentBody;

  @override
  void initState() {
    super.initState();
    // Set navigation adapter
    NavigationAdapter.setInstance(_ScreenBuilderNavigationAdapter(_loadPage));
    _loadNavigationAndHomePage();
  }

  Future<void> _loadNavigationAndHomePage() async {
    final config = screenBuilderConfig;
    if (config == null) return;

    // Load navigation JSON
    try {
      final navJson = await DefaultAssetBundle.of(context)
          .loadString(config.navigationFile);
      final navData = jsonDecode(navJson) as Map<String, dynamic>;
      setState(() {
        _navigation = navData;
      });
    } catch (e) {
      // Handle error
    }

    // Load home page
    await _loadPage(config.homePage);
  }

  Future<void> _loadPage(String pageName) async {
    debugPrint('Navigating to page: $pageName');
    final config = screenBuilderConfig;
    if (config == null) return;

    try {
      final pageJson = await DefaultAssetBundle.of(context)
          .loadString('${config.jsonPath}$pageName.json');
      final pageData = jsonDecode(pageJson) as Map<String, dynamic>;
      final components = pageData['children'] as List<dynamic>? ?? [];
      final page = PageModel(
        id: pageData['component'] ?? pageName,
        components: components.cast<Map<String, dynamic>>(),
      );
      final pageEngine = PageEngine();
      final pageWidgets = pageEngine.buildPage(page);
      setState(() {
        _currentPage = pageName;
        _currentAppBar = pageWidgets['appBar'] as PreferredSizeWidget?;
        _currentBody = pageWidgets['body'];
      });
    } catch (e) {
      // Handle error, perhaps show error page
      setState(() {
        _currentBody = const Center(child: Text('Page not found'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_navigation == null || _currentBody == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Build navigation bar from JSON
    final navItems = _navigation!['items'] as List<dynamic>? ?? [];
    final bottomNavigationBar = navItems.isNotEmpty
        ? BottomNavigationBar(
            items: navItems.map((item) {
              final icon = item['icon'] as String?;
              final label = item['label'] as String? ?? '';
              return BottomNavigationBarItem(
                icon: icon != null
                    ? const Icon(Icons.home)
                    : const Icon(Icons.error), // TODO: map icon strings
                label: label,
              );
            }).toList(),
            currentIndex:
                navItems.indexWhere((item) => item['page'] == _currentPage),
            onTap: (index) {
              final page = navItems[index]['page'] as String?;
              if (page != null) {
                _loadPage(page);
              }
            },
          )
        : null;

    return Scaffold(
      appBar: _currentAppBar,
      body: _currentBody,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
