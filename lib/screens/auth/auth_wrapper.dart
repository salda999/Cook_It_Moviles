import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Inicializar AuthService
      await AuthService.initialize();
      
      // Verificar si el usuario está logueado
      if (AuthService.isLoggedIn) {
        // Verificar que el token siga siendo válido
        final isValid = await AuthService.verifyToken();
        setState(() {
          _isLoggedIn = isValid;
        });
      } else {
        setState(() {
          _isLoggedIn = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoggedIn = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: Colors.orange,
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                color: Colors.orange,
              ),
              SizedBox(height: 16),
              Text(
                'Cook It',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Cargando...',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Si está logueado, mostrar el home, sino mostrar login
    return _isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}