import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../statusbar_color.dart';

/// The core class that handles the automatic status bar brightness recalculation.
class StatusbarColorAuto {
  StatusbarColorAuto._constructor();
  static final GlobalKey _key = GlobalKey();
  static final StatusbarColorAuto _instance = StatusbarColorAuto._constructor();
  static final StatusbarColorObserver _observer = StatusbarColorObserver();

  Duration _defaultDelay = const Duration(milliseconds: 10);

  /// The singleton instance to manually trigger [refresh].
  static StatusbarColorAuto get instance => _instance;
  
  /// The observer that should be passed to your [MaterialApp.navigatorObservers].
  StatusbarColorObserver get observer => _observer;
  
  /// The global key used internally by [StatusbarColorCapturer].
  GlobalKey get key => _key;

  /// Update the default delay before capturing the screen.
  void setDefaultDelay(Duration delay) => _defaultDelay = delay;

  /// Captures the screen, computes the luminance of the top status bar area,
  /// and automatically updates the foreground brightness.
  Future<void> refresh({Duration? delay}) async {
    return Future.delayed(delay ?? _defaultDelay, () async {
      final context = _key.currentContext;
      if (context == null) {
        debugPrint(
            'No StatusbarColorCapturer found. Please wrap your MaterialApp with StatusbarColorCapturer.');
        return;
      }

      final boundary = context.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null || !boundary.attached) return;

      try {
        // We capture the image at a low pixel ratio because we only need average colors.
        final ui.Image capturedImage = await boundary.toImage(pixelRatio: 0.5);
        
        // Extract raw RGBA bytes instantly (bypassing slow PNG compression/decompression).
        final byteData = await capturedImage.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (byteData == null) {
          capturedImage.dispose();
          return;
        }

        final bytes = byteData.buffer.asUint8List();

        final view = View.of(context);
        final mediaQuery = MediaQueryData.fromView(view);
        
        // Calculate the height of the status bar in logical pixels, clamped for safety.
        final statusHeight = mediaQuery.padding.top.clamp(20.0, 150.0);

        final width = capturedImage.width;
        // Scale the status bar height to match the captured image coordinates
        final targetHeight = (statusHeight * 0.5).toInt(); // because we used pixelRatio: 0.5

        double luminanceSum = 0.0;
        int pixels = 0;

        // Iterate over only the top part of the screen where the status bar lives
        for (int y = 0; y < targetHeight; y++) {
          for (int x = 0; x < width; x++) {
            // RGBA format has 4 bytes per pixel
            final int offset = (y * width + x) * 4;
            final int r = bytes[offset];
            final int g = bytes[offset + 1];
            final int b = bytes[offset + 2];
            // Skip the alpha channel bytes[offset + 3]
            
            // Standard relative luminance formula
            final double luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
            luminanceSum += luminance;
            pixels++;
          }
        }

        capturedImage.dispose();

        if (pixels == 0) return;

        final avgLuminance = luminanceSum / pixels;

        // If background is light (high luminance), use dark foreground text/icons (false)
        // If background is dark (low luminance), use light foreground text/icons (true)
        if (avgLuminance > 0.5) {
          await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        } else {
          await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        }
      } catch (e) {
        debugPrint('Failed to auto-update status bar brightness: $e');
      }
    });
  }
}
