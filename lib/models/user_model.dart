import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para representar a los usuarios del sistema EventTiming
class UserModel {
  final String uid;
  final String email;
  final String nombre;
  final String rol; // 'planner', 'proveedor', 'novio'
  final String? fotoUrl;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.rol,
    this.fotoUrl,
    required this.createdAt,
  });

  /// Convierte el modelo a un Map para almacenar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nombre': nombre,
      'rol': rol,
      'fotoUrl': fotoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Construye un UserModel a partir de un Map y su ID
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedCreatedAt;
    if (map['createdAt'] is Timestamp) {
      parsedCreatedAt = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is String) {
      parsedCreatedAt = DateTime.tryParse(map['createdAt']) ?? DateTime.now();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return UserModel(
      uid: id.isNotEmpty ? id : (map['uid'] ?? ''),
      email: map['email'] ?? '',
      nombre: map['nombre'] ?? '',
      rol: map['rol'] ?? 'planner',
      fotoUrl: map['fotoUrl'],
      createdAt: parsedCreatedAt,
    );
  }

  /// Construye un UserModel a partir de un DocumentSnapshot de Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel.fromMap(data, doc.id);
  }

  /// Crea una copia con propiedades modificadas
  UserModel copyWith({
    String? uid,
    String? email,
    String? nombre,
    String? rol,
    String? fotoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      rol: rol ?? this.rol,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, nombre: $nombre, rol: $rol)';
  }
}
