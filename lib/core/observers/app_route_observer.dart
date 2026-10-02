import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/route_stack_service.dart';

class AppRouteObserver extends GetObserver {

  @override
  void didPush(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    final name = route.settings.name;

    if (name != null) {
      Get.find<RouteStackService>().push(name);
    }

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    final name = route.settings.name;

    if (name != null) {
      Get.find<RouteStackService>().pop(name);
    }

    super.didPop(route, previousRoute);
  }
}