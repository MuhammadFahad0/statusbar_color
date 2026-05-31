import 'package:flutter/material.dart';
import 'statusbar_color_auto.dart';

/// A widget that must wrap your [MaterialApp] to allow [StatusbarColorAuto] 
/// to capture the screen and calculate the background brightness.
class StatusbarColorCapturer extends StatelessWidget {
  final Widget child;

  const StatusbarColorCapturer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: StatusbarColorAuto.instance.key,
      child: child,
    );
  }
}
