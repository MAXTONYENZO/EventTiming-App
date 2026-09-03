import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para representar una Tarea del cronograma en EventTiming
class TaskModel {
  final String id;
  final String eventId;
  final String proveedorId;
  final String titulo;
  final String descripcion;
  final String horaInicio;
  final String horaFin;
  final String estado; // 'pendiente', 'en_curso', 'completada'
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.eventId,
    required this.proveedorId,
    required this.titulo,
    required this.descripcion,
    required this.horaInicio,
    required this.horaFin,
    required this.estado,
    required this.isCompleted,
  });

  /// Convierte el modelo a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'proveedorId': proveedorId,
      'titulo': titulo,
      'descripcion': descripcion,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'estado': estado,
      'isCompleted': isCompleted,
    };
  }

  /// Construye un TaskModel a partir de un Map y su ID
  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    final estado = map['estado'] ?? 'pendiente';
    final isCompleted = map['isCompleted'] ?? (estado == 'completada');

    return TaskModel(
      id: id,
      eventId: map['eventId'] ?? '',
      proveedorId: map['proveedorId'] ?? '',
      titulo: map['titulo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      horaInicio: map['horaInicio'] ?? '',
      horaFin: map['horaFin'] ?? '',
      estado: estado,
      isCompleted: isCompleted,
    );
  }

  /// Construye un TaskModel a partir de un DocumentSnapshot de Firestore
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TaskModel.fromMap(data, doc.id);
  }

  /// Crea una copia con propiedades modificadas
  TaskModel copyWith({
    String? id,
    String? eventId,
    String? proveedorId,
    String? titulo,
    String? descripcion,
    String? horaInicio,
    String? horaFin,
    String? estado,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      proveedorId: proveedorId ?? this.proveedorId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      estado: estado ?? this.estado,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
