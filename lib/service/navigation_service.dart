import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToName(String name) {
    return navigatorKey.currentState!.pushNamed(name);
  }

  Future<dynamic> navigateTo(Widget widget) {
    return Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
    );
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
