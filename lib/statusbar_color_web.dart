import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

class StatusbarColorWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'plugins.sameer.com/statusbar',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = StatusbarColorWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'setstatusbarcolor':
        final int? colorValue = call.arguments['color'];
        if (colorValue != null) {
          _setThemeColor(colorValue);
        }
        return null;
      case 'getstatusbarcolor':
        return _getThemeColor();
      case 'setstatusbarwhiteforeground':
      case 'getnavigationbarcolor':
      case 'setnavigationbarcolor':
      case 'setnavigationbarwhiteforeground':
        // Web does not support these, return null silently
        return null;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'statusbar_color for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  void _setThemeColor(int colorValue) {
    // Extract RGB from ARGB integer (ignore alpha as browser meta tag accepts standard hex colors like #RRGGBB)
    final int r = (colorValue >> 16) & 0xFF;
    final int g = (colorValue >> 8) & 0xFF;
    final int b = colorValue & 0xFF;

    final String rHex = r.toRadixString(16).padLeft(2, '0');
    final String gHex = g.toRadixString(16).padLeft(2, '0');
    final String bHex = b.toRadixString(16).padLeft(2, '0');
    final String hexColor = '#$rHex$gHex$bHex';

    // Find or create <meta name="theme-color">
    var meta = web.document.querySelector('meta[name="theme-color"]')
        as web.HTMLMetaElement?;
    if (meta == null) {
      meta = web.document.createElement('meta') as web.HTMLMetaElement;
      meta.name = 'theme-color';
      web.document.head?.appendChild(meta);
    }
    meta.content = hexColor;
  }

  int? _getThemeColor() {
    final meta = web.document.querySelector('meta[name="theme-color"]')
        as web.HTMLMetaElement?;
    if (meta == null || meta.content.isEmpty) return null;

    final colorStr = meta.content.replaceAll('#', '');
    if (colorStr.length == 6) {
      // Return ARGB value with FF as alpha (fully opaque)
      return int.parse('FF$colorStr', radix: 16);
    }
    return null;
  }
}
