import 'package:flutter/foundation.dart';

/// Servicio para gestión y despacho de notificaciones locales y recordatorios de tareas
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Inicializa el servicio de notificaciones
  Future<void> initialize() async {
    try {
      // En un entorno de producción, aquí se inicializa flutter_local_notifications
      // o Firebase Cloud Messaging (FCM).
      _isInitialized = true;
      debugPrint('[NotificationService] Servicio de notificaciones inicializado correctamente.');
    } catch (e) {
      debugPrint('[NotificationService] Error al inicializar notificaciones: $e');
    }
  }

  /// Despacha una notificación o alerta visual para una tarea
  Future<void> notifyTaskStatusChange({
    required String taskTitle,
    required String newStatus,
  }) async {
    debugPrint('[NotificationService] Notificación de tarea "$taskTitle": cambió a estado $newStatus');
  }

  /// Programa o simula recordatorio de inicio de tarea
  Future<void> scheduleTaskReminder({
    required String taskTitle,
    required String horaInicio,
  }) async {
    debugPrint('[NotificationService] Recordatorio programado para "$taskTitle" a las $horaInicio');
  }
}
