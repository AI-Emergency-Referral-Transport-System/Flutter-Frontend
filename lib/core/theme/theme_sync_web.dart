// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

/// Keeps pre-Flutter web shell and CSS variables aligned with app theme.
void applyWebThemeMode(String mode) {
  final isDark = mode == 'dark';
  html.document.documentElement?.setAttribute(
    'data-theme',
    isDark ? 'dark' : 'light',
  );
  try {
    html.window.localStorage['derash_theme_mode'] = mode;
  } catch (_) {}
}
