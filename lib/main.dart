import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/timeline_screen.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('[Firebase Init Warning] Firebase no configurado aún o en entorno local: $e');
  }

  // Inicializar servicio de notificaciones
  await NotificationService().initialize();

  runApp(const EventTimingApp());
}

/// Aplicación Principal EventTiming
class EventTimingApp extends StatelessWidget {
  const EventTimingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Servicio de Autenticación
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Servicio de Base de Datos Cloud Firestore
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        // Stream reactivo del usuario autenticado
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'EventTiming',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            primary: AppConstants.primaryColor,
            secondary: AppConstants.secondaryColor,
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: false,
          ),
          cardTheme: CardThemeData(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
        ),
        initialRoute: AppConstants.routeSplash,
        routes: {
          AppConstants.routeSplash: (context) => const SplashScreen(),
          AppConstants.routeLogin: (context) => const LoginScreen(),
          AppConstants.routeRegister: (context) => const RegisterScreen(),
          AppConstants.routeTimeline: (context) => const TimelineScreen(),
        },
      ),
    );
  }
}