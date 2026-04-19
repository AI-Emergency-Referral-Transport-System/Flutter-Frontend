import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth_user.dart';
import '../domain/user_role.dart';

class AuthRepository {
  AuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboarding = 'derash_onboarding_done';
  static const _kToken = 'derash_auth_token';
  static const _kUser = 'derash_user_json';

  bool get onboardingComplete => _prefs.getBool(_kOnboarding) ?? false;

  Future<void> setOnboardingComplete() => _prefs.setBool(_kOnboarding, true);

  AuthUser? readUser() {
    final raw = _prefs.getString(_kUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      return AuthUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  bool get isLoggedIn {
    final t = _prefs.getString(_kToken);
    return t != null && t.isNotEmpty && readUser() != null;
  }

  Future<void> saveSession(AuthUser user) async {
    // TODO(backend): store JWT from your auth API instead of a fixed placeholder.
    await _prefs.setString(_kToken, 'session');
    await _prefs.setString(_kUser, jsonEncode(user.toJson()));
  }

  Future<void> clearSession() async {
    await _prefs.remove(_kToken);
    await _prefs.remove(_kUser);
  }

  UserRole? readLastRole() =>
      UserRoleX.fromStorage(_prefs.getString('derash_last_role'));

  Future<void> setLastRole(UserRole role) =>
      _prefs.setString('derash_last_role', role.storageValue);
}
