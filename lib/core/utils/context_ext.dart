import 'package:flutter/material.dart';

extension NavigatorContext on BuildContext {
  void pop<T extends Object?>([T? result]) {
    return Navigator.of(this).pop(result);
  }

  void push(Widget page) {
    Navigator.of(this).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future showFullScreenDialog(Widget route) async {
    return Navigator.of(this).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => route,
      ),
    );
  }

  Future<void> pushReplacement(Widget page) async {
    await Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void pushAndRemoveUntil(
      Widget page, bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      predicate,
    );
  }

  Future<bool> maybePop<T extends Object?>([T? result]) {
    return Navigator.of(this).maybePop(result);
  }

  void popUntil(RoutePredicate predicate) {
    return Navigator.of(this).popUntil(predicate);
  }

  bool canPop() {
    return Navigator.of(this).canPop();
  }
}
