import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/route_stack_service.dart';

class AppRouteObserver extends GetObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = route.settings.name;

    if (name != null) {
      Get.find<RouteStackService>().push(name);
    }

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = route.settings.name;

    if (name != null) {
      Get.find<RouteStackService>().pop(name);
    }

    super.didPop(route, previousRoute);
  }

  // Tambahan untuk saat pakai Get.offAllNamed() Stack sinkron dan terhapus semua stack yang ada

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = _routeName(route);

    if (name != null) {
      Get.find<RouteStackService>().pop(name);
    }

    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final oldName = _routeName(oldRoute);
    final newName = _routeName(newRoute);

    if (oldName != null) {
      Get.find<RouteStackService>().pop(oldName);
    }

    if (newName != null) {
      Get.find<RouteStackService>().push(newName);
    }

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  String? _routeName(Route<dynamic>? route) {
    return route?.settings.name;
  }
}
