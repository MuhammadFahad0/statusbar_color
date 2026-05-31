# statusbar_color

[![pub package](https://img.shields.io/pub/v/statusbar_color?style=for-the-badge)](https://pub.dev/packages/statusbar_color)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A modernized Flutter plugin to programmatically change your app's status bar and navigation bar colors.

This is a completely revamped, null-safe version of the original `flutter_statusbarcolor` package, brought up to date with modern Flutter requirements. It includes safe iOS scene window implementations, Flutter Web support, and full Android V2 embedding compatibility.

## ✨ Features

- **Null Safety**: 100% migrated to Dart null safety.
- **Modern iOS Implementation**: Avoids private APIs and uses scene-safe UIWindow access, avoiding App Store rejections.
- **Web Support**: Seamlessly alters the browser's `theme-color` meta tag on the web.
- **Android V2 Embedding**: Fully compatible with the latest Android Flutter architecture.
- **Color Manipulation**: Programmatically adjust both the background color and foreground icon brightness (light/dark) for the status bar and navigation bar.

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  statusbar_color: ^0.0.3
```

Import the package in your Dart code:

```dart
import 'package:statusbar_color/statusbar_color.dart';
```

## 💻 Usage

### Changing Status Bar Color

```dart
// Change the status bar color to a Material color (e.g., green[400])
await FlutterStatusbarcolor.setStatusBarColor(Colors.green[400]!);

// Automatically adjust the foreground (icons/text) brightness based on the background
if (useWhiteForeground(Colors.green[400]!)) {
  FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
} else {
  FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
}
```

### Changing Navigation Bar Color (Android only)

```dart
// Change the navigation bar color to a Material color (e.g., orange[200])
await FlutterStatusbarcolor.setNavigationBarColor(Colors.orange[200]!);

// Automatically adjust the navigation bar icons' brightness
if (useWhiteForeground(Colors.orange[200]!)) {
  FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
} else {
  FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
}
```

### Retrieving Current Colors

```dart
Color? statusbarColor = await FlutterStatusbarcolor.getStatusBarColor();
Color? navigationbarColor = await FlutterStatusbarcolor.getNavigationBarColor();
```

### Automatic Status Bar Brightness (Auto Background Detection)

Similar to the `statusbarz` package, `statusbar_color` can automatically detect the background color behind the status bar and adjust the icon brightness accordingly. Our implementation is **highly optimized**, using raw `RGBA` byte inspection rather than heavy PNG compression, guaranteeing 0 stuttering during route transitions.

1. Wrap your `MaterialApp` with `StatusbarColorCapturer`.
2. Add `StatusbarColorAuto.instance.observer` to your `navigatorObservers`.

```dart
void main() {
  runApp(
    StatusbarColorCapturer(
      child: MaterialApp(
        navigatorObservers: [StatusbarColorAuto.instance.observer],
        home: const MyHomePage(),
      ),
    ),
  );
}
```

Whenever a new page is pushed or popped, the observer will automatically take a snapshot of the top of the screen, calculate the average luminance, and update the status bar text/icons to either light or dark.

You can also trigger it manually at any time:

```dart
StatusbarColorAuto.instance.refresh();
```

## 📱 Supported Platforms & API Levels

| Platform | Feature | Minimum API / OS Version |
| :--- | :--- | :--- |
| **Android** | `getStatusBarColor` | API 21 (5.0) |
| | `setStatusBarColor` | API 21 (5.0) |
| | `setStatusBarWhiteForeground` | API 23 (6.0) |
| | `getNavigationBarColor` | API 21 (5.0) |
| | `setNavigationBarColor` | API 21 (5.0) |
| | `setNavigationBarWhiteForeground` | API 26 (8.0) |
| **iOS** | `getStatusBarColor` | iOS 7+ |
| | `setStatusBarColor` | iOS 7+ |
| | `setStatusBarWhiteForeground` | iOS 7+ |
| **Web** | `getStatusBarColor` | All major browsers |
| | `setStatusBarColor` | Browsers supporting `<meta name="theme-color">` |

## ⚠️ Notes & Best Practices

- **Lifecycle Changes**: If you notice the foreground brightness reverts after minimizing and resuming the app, listen to the app's lifecycle state using Flutter's `WidgetsBindingObserver` mixin and re-apply the styling in the `didChangeAppLifecycleState` method.
- **iOS Transparency**: Some iOS configurations might require tweaking `Info.plist` (such as `UIViewControllerBasedStatusBarAppearance`) for optimal foreground brightness manipulation.

## ❤️ Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/MuhammadFahad0/statusbar_color/issues) and the [pull requests page](https://github.com/MuhammadFahad0/statusbar_color/pulls).
