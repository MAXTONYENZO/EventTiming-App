import 'package:flutter/material.dart';

/// Constantes generales de diseño, rutas y estilos para EventTiming
class AppConstants {
  // --- Colores Principales ---
  static const Color primaryColor = Color(0xFF1976D2); // Azul principal (#1976D2)
  static const Color primaryDarkColor = Color(0xFF0D47A1);
  static const Color secondaryColor = Color(0xFF757575); // Gris secundario (#757575)
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF616161);

  // --- Colores de Estado de Tareas ---
  static const Color statusPendingColor = Color(0xFFFB8C00); // Naranja (#FB8C00)
  static const Color statusInProgressColor = Color(0xFF1976D2); // Azul (#1976D2)
  static const Color statusCompletedColor = Color(0xFF43A047); // Verde (#43A047)

  // --- Sombras y Radios de Borde ---
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 3.0;

  // --- Espaciados ---
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double paddingExtraLarge = 24.0;

  // --- Tipografías y Estilos de Texto ---
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    letterSpacing: 0.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
  );

  static const TextStyle bodyTextSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // --- Rutas de Navegación ---
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeTimeline = '/timeline';

  // --- Claves de Almacenamiento Seguro (flutter_secure_storage) ---
  static const String storageTokenKey = 'eventtiming_jwt_token';
  static const String storageUserUidKey = 'eventtiming_user_uid';
  static const String storageUserRoleKey = 'eventtiming_user_role';

  // --- Mensajes de Error Comunes ---
  static const String errRequiredField = 'Este campo es obligatorio';
  static const String errInvalidEmail = 'Ingresa un correo electrónico válido';
  static const String errShortPassword = 'La contraseña debe tener al menos 6 caracteres';
  static const String errPasswordMismatch = 'Las contraseñas no coinciden';
  static const String errGeneric = 'Ha ocurrido un error inesperado. Inténtalo de nuevo.';
}
