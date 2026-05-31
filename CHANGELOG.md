## 0.0.5

*   **SDK Target Bump:** Bumped Android target and compile SDK to version 36 (Android 16).

## 0.0.4

*   **New Feature:** Added Automatic Background Detection (`StatusbarColorAuto` and `StatusbarColorCapturer`) to automatically adjust status bar text/icon brightness based on the background color.
*   **Performance:** Implemented raw RGBA byte extraction for instant, zero-stutter background detection.
*   **Documentation:** Rewrote `README.md` to be more comprehensive and modern.
*   **Cleanup:** Removed outdated IDE and configuration files.

## 0.0.1

*   **Null Safety:** Fully migrated the package to Dart Null Safety.
*   **Modern iOS APIs:** Refactored iOS native code to avoid private APIs (App Store safe) and support scene-based UIWindow retrieval.
*   **Web Support:** Added Flutter Web platform support to manipulate the browser's `theme-color` meta tag dynamically.
*   **Android:** Maintained full support for Android V2 Embedding.