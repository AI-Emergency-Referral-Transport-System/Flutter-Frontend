import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_sync.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(ThemeMode.system);

  static const _key = 'app_theme_mode';
  final SharedPreferences _prefs;

  void _applyWebHint(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        applyWebThemeMode('dark');
      case ThemeMode.light:
        applyWebThemeMode('light');
      case ThemeMode.system:
        final dark =
            SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark;
        applyWebThemeMode(dark ? 'dark' : 'light');
    }
  }

  void load() {
    final raw = _prefs.getString(_key);
    final mode = switch (raw) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
    emit(mode);
    _applyWebHint(mode);
  }

  void setThemeMode(ThemeMode mode) {
    emit(mode);
    final stored = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    _prefs.setString(_key, stored);
    _applyWebHint(mode);
  }
}
