/// Simple dependency injection container
class DIContainer {
  static final DIContainer _instance = DIContainer._internal();
  factory DIContainer() => _instance;
  DIContainer._internal();

  final Map<Type, dynamic> _services = {};

  /// Registers a service
  void register<T>(T service) {
    _services[T] = service;
  }

  /// Gets a service
  T get<T>() {
    return _services[T] as T;
  }

  /// Checks if a service is registered
  bool has<T>() {
    return _services.containsKey(T);
  }
}
