import 'package:flutter_test/flutter_test.dart';
import 'package:event_timing/models/user_model.dart';
import 'package:event_timing/models/event_model.dart';
import 'package:event_timing/models/task_model.dart';
import 'package:event_timing/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('Validador de correo electrónico', () {
      expect(Validators.validateEmail(null), isNotNull);
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('correo_invalido'), isNotNull);
      expect(Validators.validateEmail('usuario@dominio'), isNotNull);
      expect(Validators.validateEmail('usuario@dominio.com'), isNull);
      expect(Validators.validateEmail('admin.eventos@agencia.org'), isNull);
    });

    test('Validador de contraseñas', () {
      expect(Validators.validatePassword(null), isNotNull);
      expect(Validators.validatePassword('123'), isNotNull);
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('passwordSegura2026'), isNull);
    });

    test('Validador de confirmación de contraseñas', () {
      expect(Validators.validateConfirmPassword('123456', '123456'), isNull);
      expect(Validators.validateConfirmPassword('123456', '654321'), isNotNull);
      expect(Validators.validateConfirmPassword(null, '123456'), isNotNull);
    });

    test('Validador de campo requerido', () {
      expect(Validators.validateNotEmpty(null), isNotNull);
      expect(Validators.validateNotEmpty('   '), isNotNull);
      expect(Validators.validateNotEmpty('Texto válido'), isNull);
    });
  });

  group('Model Serialization Tests', () {
    test('UserModel toMap y fromMap', () {
      final now = DateTime.now();
      final user = UserModel(
        uid: 'usr_123',
        email: 'planner@eventtiming.com',
        nombre: 'Sofía Martínez',
        rol: 'planner',
        fotoUrl: 'https://example.com/foto.jpg',
        createdAt: now,
      );

      final map = user.toMap();
      expect(map['email'], 'planner@eventtiming.com');
      expect(map['rol'], 'planner');

      final deserialized = UserModel.fromMap(map, 'usr_123');
      expect(deserialized.uid, 'usr_123');
      expect(deserialized.nombre, 'Sofía Martínez');
      expect(deserialized.rol, 'planner');
    });

    test('EventModel toMap y fromMap', () {
      final now = DateTime.now();
      final event = EventModel(
        id: 'evt_456',
        nombre: 'Boda Andrea & Miguel',
        fecha: '2026-10-15',
        hora: '17:00',
        lugar: 'Hacienda Los Laureles',
        plannerId: 'usr_123',
        proveedoresIds: ['prov_1', 'prov_2'],
        estado: 'planificacion',
        createdAt: now,
      );

      final map = event.toMap();
      expect(map['nombre'], 'Boda Andrea & Miguel');
      expect(map['lugar'], 'Hacienda Los Laureles');

      final deserialized = EventModel.fromMap(map, 'evt_456');
      expect(deserialized.id, 'evt_456');
      expect(deserialized.plannerId, 'usr_123');
      expect(deserialized.proveedoresIds.length, 2);
    });

    test('TaskModel toMap, fromMap y copyWith', () {
      final task = TaskModel(
        id: 'tsk_789',
        eventId: 'evt_456',
        proveedorId: 'prov_floreria',
        titulo: 'Montaje de arreglos florales',
        descripcion: 'Colocación de centros de mesa en salón principal',
        horaInicio: '14:00',
        horaFin: '16:00',
        estado: 'pendiente',
        isCompleted: false,
      );

      final map = task.toMap();
      expect(map['titulo'], 'Montaje de arreglos florales');
      expect(map['estado'], 'pendiente');
      expect(map['isCompleted'], false);

      final deserialized = TaskModel.fromMap(map, 'tsk_789');
      expect(deserialized.id, 'tsk_789');
      expect(deserialized.horaInicio, '14:00');

      final updated = deserialized.copyWith(
        estado: 'completada',
        isCompleted: true,
      );
      expect(updated.estado, 'completada');
      expect(updated.isCompleted, true);
      expect(updated.titulo, 'Montaje de arreglos florales');
    });
  });
}
