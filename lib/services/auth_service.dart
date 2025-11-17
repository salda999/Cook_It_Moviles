import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // static const String _baseUrl = 'http://10.0.2.2:3000/api/auth'; // Para emulador Android
  static const String _baseUrl = 'http://localhost:3000/api/auth'; // Para desarrollo web
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Usuario actual
  static Map<String, dynamic>? _currentUser;
  static String? _currentToken;
  
  /// Inicializar el servicio cargando datos del almacenamiento local
  static Future<void> initialize() async {
    await _loadStoredAuth();
  }
  
  /// Cargar autenticación almacenada
  static Future<void> _loadStoredAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentToken = prefs.getString(_tokenKey);
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        _currentUser = json.decode(userJson);
      }
    } catch (e) {
      _currentToken = null;
      _currentUser = null;
    }
  }
  
  /// Guardar autenticación en almacenamiento local
  static Future<void> _saveAuth(String token, Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userKey, json.encode(user));
      
      _currentToken = token;
      _currentUser = user;
    } catch (e) {
      throw Exception('Error guardando datos de autenticación');
    }
  }
  
  /// Limpiar autenticación del almacenamiento local
  static Future<void> _clearAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      
      _currentToken = null;
      _currentUser = null;
    } catch (e) {
      // Error silencioso al limpiar
    }
  }
  
  /// Registrar nuevo usuario
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      print('AuthService: Intentando registrar usuario en: $_baseUrl/register');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      ).timeout(const Duration(seconds: 10));
      
      print('AuthService: Respuesta recibida - Status: ${response.statusCode}');
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 201 && data['success']) {
        // Guardar autenticación
        await _saveAuth(data['data']['token'], data['data']['user']);
        
        return {
          'success': true,
          'message': data['message'],
          'user': data['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error en el registro',
          'errors': data['errors'] ?? [],
        };
      }
    } catch (e) {
      print('AuthService: Error en registro - $e');
      
      if (e.toString().contains('TimeoutException')) {
        return {
          'success': false,
          'message': 'Tiempo de conexión agotado. Verifica que el servidor esté funcionando.',
        };
      }
      
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
  
  /// Iniciar sesión
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success']) {
        // Guardar autenticación
        await _saveAuth(data['data']['token'], data['data']['user']);
        
        return {
          'success': true,
          'message': data['message'],
          'user': data['data']['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Credenciales inválidas',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión. Verifica tu conexión a internet.',
      };
    }
  }
  
  /// Cerrar sesión
  static Future<void> logout() async {
    await _clearAuth();
  }
  
  /// Verificar si el usuario está autenticado
  static bool get isLoggedIn => _currentToken != null && _currentUser != null;
  
  /// Obtener usuario actual
  static Map<String, dynamic>? get currentUser => _currentUser;
  
  /// Obtener token actual
  static String? get currentToken => _currentToken;
  
  /// Verificar validez del token con el servidor
  static Future<bool> verifyToken() async {
    if (_currentToken == null) return false;
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_currentToken',
        },
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success']) {
        return true;
      } else {
        // Token inválido, limpiar autenticación
        await _clearAuth();
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  
  /// Obtener información actualizada del usuario
  static Future<Map<String, dynamic>?> getUserInfo() async {
    if (_currentToken == null) return null;
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_currentToken',
        },
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success']) {
        return data['data']['user'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}