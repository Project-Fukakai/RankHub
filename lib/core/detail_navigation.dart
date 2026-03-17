import 'package:flutter/material.dart';
import 'package:rank_hub/core/navigation_keys.dart';

const double kThreeColumnBreakpoint = 1024.0;

Future<T?> pushDetailPage<T>(
  BuildContext context,
  Widget page, {
  bool replaceOnThreeColumn = true,
}) {
  final isThreeColumn =
      MediaQuery.of(context).size.width >= kThreeColumnBreakpoint;
  final route = MaterialPageRoute<T>(builder: (context) => page);

  if (isThreeColumn) {
    final navigator = detailBranchNavigatorKey.currentState;
    if (navigator != null) {
      if (replaceOnThreeColumn) {
        return navigator.pushReplacement(route);
      }
      return navigator.push(route);
    }
  }

  return Navigator.of(context).push(route);
}
