import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteStackService extends GetxService {
  final List<String> stack = [];

  bool contains(String route) {
    return stack.contains(route);
  }

  void push(String route) {
    stack.add(route);
    debugPrint('ROUTE PUSH: $route');
    debugPrint('ROUTE STACK: $stack');
  }

  void pop(String route) {
    stack.remove(route);
    debugPrint('ROUTE POP: $route');
    debugPrint('ROUTE STACK: $stack');
  }
}