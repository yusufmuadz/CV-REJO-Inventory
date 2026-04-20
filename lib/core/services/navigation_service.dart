import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => navigatorKey.currentState;

  /// Push page
  Future<T?> push<T>(Widget page) {
    return _navigator!.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push named
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return _navigator!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace page
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return _navigator!.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Replace with named
  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
    );
  }

  /// Clear all & push
  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return _navigator!.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Pop
  void pop<T>([T? result]) {
    _navigator!.pop(result);
  }

  /// Pop until
  void popUntil(String routeName) {
    _navigator!.popUntil(ModalRoute.withName(routeName));
  }
}