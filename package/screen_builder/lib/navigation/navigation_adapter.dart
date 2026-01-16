/// Adapter for navigation
abstract class NavigationAdapter {
  void navigate(String route);

  static NavigationAdapter? _instance;

  static void setInstance(NavigationAdapter adapter) {
    _instance = adapter;
  }

  static NavigationAdapter? get instance => _instance;
}
