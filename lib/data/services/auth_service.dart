import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        
        // Save tokens
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.keyAccessToken, data['accessToken']);
        if (data['refreshToken'] != null) {
          await prefs.setString(AppConstants.keyRefreshToken, data['refreshToken']);
        }
        
        // Save user data
        final user = UserModel.fromJson(data['user']);
        await prefs.setString(AppConstants.keyUserData, jsonEncode(user.toJson()));
        await prefs.setString(AppConstants.keyUserRole, user.role);
        
        return {
          'success': true,
          'user': user,
          'message': response.data['message'],
        };
      }
      
      return {
        'success': false,
        'message': response.data['message'] ?? 'Login failed',
      };
    } catch (e) {
      // Better error handling
      String errorMessage = 'Login failed';
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        errorMessage = 'Cannot connect to server. Please check if backend is running on http://localhost:5000';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timeout. Please check your internet connection';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Invalid email or password';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Account not found. Please create an account first';
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  // Register
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        data: userData,
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];
        
        // Save tokens
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.keyAccessToken, data['accessToken']);
        if (data['refreshToken'] != null) {
          await prefs.setString(AppConstants.keyRefreshToken, data['refreshToken']);
        }
        
        // Save user data
        final user = UserModel.fromJson(data['user']);
        await prefs.setString(AppConstants.keyUserData, jsonEncode(user.toJson()));
        await prefs.setString(AppConstants.keyUserRole, user.role);
        
        return {
          'success': true,
          'user': user,
          'message': response.data['message'],
        };
      }
      
      return {
        'success': false,
        'message': response.data['message'] ?? 'Registration failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if API fails
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyAccessToken) != null;
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.keyUserData);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Get user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyUserRole);
  }
}
