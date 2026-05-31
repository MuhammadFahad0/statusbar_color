import 'package:flutter/material.dart';
import 'statusbar_color_auto.dart';

/// A [NavigatorObserver] that listens to route changes and automatically 
/// triggers the status bar color recalculation.
class StatusbarColorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    StatusbarColorAuto.instance.refresh();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    StatusbarColorAuto.instance.refresh();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    StatusbarColorAuto.instance.refresh();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    StatusbarColorAuto.instance.refresh();
  }
}
