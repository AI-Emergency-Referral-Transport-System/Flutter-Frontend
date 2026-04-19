import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_session_model.dart';

class AuthLocalDataSource {
  static const _sessionKey = 'auth_session';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<void> saveSession(AuthSessionModel session) async {
    final prefs = await _prefs;
    await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  Future<AuthSessionModel?> readSession() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return AuthSessionModel.fromJson(decoded);
  }

  Future<String?> getAccessToken() async => (await readSession())?.access;
  Future<String?> getRefreshToken() async => (await readSession())?.refresh;

  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
  }
}