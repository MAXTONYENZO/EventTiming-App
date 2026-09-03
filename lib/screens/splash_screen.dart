import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/loading_widget.dart';
import 'login_screen.dart';
import 'timeline_screen.dart';

/// Pantalla de bienvenida que verifica el estado de autenticación del usuario
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// Verifica si existe una sesión activa y redirige a la pantalla correspondiente
  Future<void> _checkAuthStatus() async {
    // Breve retraso para mostrar la identidad de la marca
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser;

    if (currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TimelineScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Ícono representativo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.event_available_rounded,
                  size: 54,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Nombre de la App
              const Text(
                'EventTiming',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryDarkColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Eslogan
              Text(
                'Coordinación de eventos en tiempo real',
                style: AppConstants.bodyTextSecondary.copyWith(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 48),

              // Indicador de carga
              const LoadingWidget(message: 'Verificando sesión...'),
            ],
          ),
        ),
      ),
    );
  }
}
