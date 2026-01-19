import 'package:flutter/material.dart';
import 'bootstrap.dart';
import 'engine/page_engine.dart';
import 'models/page_model.dart';
import 'dart:convert';

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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Navigation is now handled by NavigationHandle in the centralized architecture
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
      // Ensure the PageModel contains the full page (root) so PageEngine
      // can detect a 'screen' root and build a Scaffold.
      final page = PageModel(
        id: pageData['component'] ?? pageName,
        components: [pageData.cast<String, dynamic>()],
      );
      debugPrint('Loaded page data: $pageData');
      final pageEngine = PageEngine();
      final pageWidget = pageEngine.buildPage(context, page);
      setState(() {
        _currentPage = pageName;
        if (pageWidget is Scaffold) {
          _currentAppBar = pageWidget.appBar;
          _currentBody = pageWidget.body;
        } else {
          _currentAppBar = null;
          _currentBody = pageWidget;
        }
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
            currentIndex: _selectedIndex,
            onTap: (index) {
              final page = navItems[index]['page'] as String?;
              if (page != null) {
                setState(() {
                  _selectedIndex = index;
                });
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
