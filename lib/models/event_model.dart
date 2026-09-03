import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para representar un Evento en EventTiming
class EventModel {
  final String id;
  final String nombre;
  final String fecha;
  final String hora;
  final String lugar;
  final String plannerId;
  final List<String> proveedoresIds;
  final String estado; // 'planificacion', 'en_curso', 'finalizado'
  final DateTime createdAt;

  const EventModel({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.plannerId,
    required this.proveedoresIds,
    required this.estado,
    required this.createdAt,
  });

  /// Convierte el modelo a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fecha': fecha,
      'hora': hora,
      'lugar': lugar,
      'plannerId': plannerId,
      'proveedoresIds': proveedoresIds,
      'estado': estado,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Construye un EventModel a partir de un Map y su ID
  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedCreatedAt;
    if (map['createdAt'] is Timestamp) {
      parsedCreatedAt = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is String) {
      parsedCreatedAt = DateTime.tryParse(map['createdAt']) ?? DateTime.now();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return EventModel(
      id: id,
      nombre: map['nombre'] ?? '',
      fecha: map['fecha'] ?? '',
      hora: map['hora'] ?? '',
      lugar: map['lugar'] ?? '',
      plannerId: map['plannerId'] ?? '',
      proveedoresIds: List<String>.from(map['proveedoresIds'] ?? []),
      estado: map['estado'] ?? 'planificacion',
      createdAt: parsedCreatedAt,
    );
  }

  /// Construye un EventModel a partir de un DocumentSnapshot de Firestore
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return EventModel.fromMap(data, doc.id);
  }

  /// Crea una copia con propiedades modificadas
  EventModel copyWith({
    String? id,
    String? nombre,
    String? fecha,
    String? hora,
    String? lugar,
    String? plannerId,
    List<String>? proveedoresIds,
    String? estado,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      lugar: lugar ?? this.lugar,
      plannerId: plannerId ?? this.plannerId,
      proveedoresIds: proveedoresIds ?? this.proveedoresIds,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
