import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final http.Client httpClient = http.Client();
  late SharedPreferences _prefs;
  bool _initialized = false;

  AuthService();

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      _initialized = false;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  /// Login user dengan email dan password
  Future<User> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.loginEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('DEBUG: Login response: $jsonResponse');
        
        if (jsonResponse['success'] == true) {
          // Backend return data.user, bukan data langsung
          final userJson = jsonResponse['data']['user'];
          final token = jsonResponse['data']['token'];
          
          final userData = User.fromJson(userJson);
          print('DEBUG: User from response: ${userData.toJson()}');
          final tokenUser = userData.copyWith(token: token);
          
          // Simpan token dan user data
          await _prefs.setString(AppConstants.tokenKey, token);
          await _prefs.setString(AppConstants.userKey, jsonEncode(tokenUser.toJson()));
          print('DEBUG: Saved user data: ${tokenUser.toJson()}');
          
          return tokenUser;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Login gagal');
        }
      } else {
        throw Exception('Login gagal. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error login: ${e.toString()}');
    }
  }

  /// Register user baru
  Future<User> register(
      String name, String email, String password, String passwordConfirmation) async {
    try {
      final response = await httpClient.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.registerEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          // Backend return data.user, bukan data langsung
          final userJson = jsonResponse['data']['user'];
          final token = jsonResponse['data']['token'];
          
          final userData = User.fromJson(userJson);
          final tokenUser = userData.copyWith(token: token);
          
          // Simpan token dan user data
          await _prefs.setString(AppConstants.tokenKey, token);
          await _prefs.setString(AppConstants.userKey, jsonEncode(tokenUser.toJson()));
          
          return tokenUser;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Registrasi gagal');
        }
      } else {
        throw Exception('Registrasi gagal. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error registrasi: ${e.toString()}');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final token = _prefs.getString(AppConstants.tokenKey);
      
      if (token != null) {
        await httpClient.post(
          Uri.parse('${AppConstants.baseUrl}${AppConstants.logoutEndpoint}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      }
      
      // Hapus token dan user data dari storage
      await _prefs.remove(AppConstants.tokenKey);
      await _prefs.remove(AppConstants.userKey);
    } catch (e) {
      // Tetap hapus data lokal meskipun API call gagal
      await _prefs.remove(AppConstants.tokenKey);
      await _prefs.remove(AppConstants.userKey);
    }
  }

  /// Get token yang tersimpan
  Future<String?> getToken() async {
    await _ensureInitialized();
    return _prefs.getString(AppConstants.tokenKey);
  }

  /// Get user data yang tersimpan
  Future<User?> getCurrentUser() async {
    await _ensureInitialized();
    final userData = _prefs.getString(AppConstants.userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  /// Check apakah user sudah login
  Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    return _prefs.containsKey(AppConstants.tokenKey);
  }
}

extension on User {
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
