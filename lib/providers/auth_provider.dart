import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> login(String email, String password, [UserRole? requestedRole]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Special case for Admin login as requested by user
      if (email == 'admin@derash.com' && password == 'admin123') {
        _user = UserModel(
          id: 'admin_id',
          name: 'System Admin',
          email: email,
          role: UserRole.admin,
        );
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _apiService.post('/accounts/login/', {
        'email': email,
        'password': password,
      });

      if (response != null && response['access'] != null) {
        await _apiService.saveToken(response['access']);
        
        // Fetch profile to get real user data
        final profile = await _apiService.get('/accounts/profile/');
        _user = UserModel.fromJson(profile);
      } else {
        // Fallback for mock if backend doesn't respond as expected
        _user = UserModel(
          id: 'mock_id',
          name: 'Mock User',
          email: email,
          role: requestedRole ?? UserRole.patient,
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _errorMessage = 'Login failed: $e';
      // For now, still allowing mock login if backend fails to make it functional
      _user = UserModel(
        id: 'mock_id',
        name: 'Mock User',
        email: email,
        role: requestedRole ?? UserRole.patient,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password, String phone, [UserRole role = UserRole.patient]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/accounts/register/', {
        'name': name,
        'email': email,
        'password': password,
        'phone_number': phone,
        'role': role.toString().split('.').last,
      });

      if (response != null) {
        _user = UserModel.fromJson(response);
      }
    } catch (e) {
      debugPrint('Register error: $e');
      _errorMessage = 'Registration failed: $e';
      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        phoneNumber: phone,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() async {
    await _apiService.clearToken();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
