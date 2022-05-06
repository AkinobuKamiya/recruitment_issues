import 'package:flutter/material.dart';
import 'package:recruitment_issues/main.dart';
import 'package:recruitment_issues/service/navigation_service.dart';

class BaseChangeNotifier extends ChangeNotifier {
  NavigationService get navigationService => locator<NavigationService>();
}
