import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../models/task_model.dart';

/// Servicio de gestión de base de datos Cloud Firestore para Eventos y Tareas
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ===========================================================================
  // COLECCIÓN: EVENTOS
  // ===========================================================================

  CollectionReference get _eventsCollection => _firestore.collection('events');

  /// Crea un nuevo evento en Firestore
  Future<void> createEvent(EventModel event) async {
    try {
      if (event.id.isNotEmpty) {
        await _eventsCollection.doc(event.id).set(event.toMap());
      } else {
        await _eventsCollection.add(event.toMap());
      }
    } catch (e) {
      throw Exception('Error al crear el evento: ${e.toString()}');
    }
  }

  /// Obtiene los eventos creados por un planner específico
  Future<List<EventModel>> getEventsByPlanner(String plannerId) async {
    try {
      final querySnapshot = await _eventsCollection
          .where('plannerId', isEqualTo: plannerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener eventos del planner: ${e.toString()}');
    }
  }

  /// Stream reactivo de eventos asociados a un planner
  Stream<List<EventModel>> streamEventsByPlanner(String plannerId) {
    return _eventsCollection
        .where('plannerId', isEqualTo: plannerId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList());
  }

  /// Obtiene un evento por su ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      final doc = await _eventsCollection.doc(eventId).get();
      if (doc.exists) {
        return EventModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error al consultar evento: ${e.toString()}');
    }
  }

  /// Actualiza la información de un evento existente
  Future<void> updateEvent(EventModel event) async {
    try {
      await _eventsCollection.doc(event.id).update(event.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el evento: ${e.toString()}');
    }
  }

  /// Elimina un evento y sus tareas vinculadas
  Future<void> deleteEvent(String eventId) async {
    try {
      // Eliminar las tareas asociadas al evento
      final tasksSnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .get();

      final batch = _firestore.batch();
      for (var doc in tasksSnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(_eventsCollection.doc(eventId));
      await batch.commit();
    } catch (e) {
      throw Exception('Error al eliminar el evento: ${e.toString()}');
    }
  }

  // ===========================================================================
  // COLECCIÓN: TAREAS
  // ===========================================================================

  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  /// Crea una nueva tarea en el cronograma
  Future<void> createTask(TaskModel task) async {
    try {
      if (task.id.isNotEmpty) {
        await _tasksCollection.doc(task.id).set(task.toMap());
      } else {
        await _tasksCollection.add(task.toMap());
      }
    } catch (e) {
      throw Exception('Error al registrar la tarea: ${e.toString()}');
    }
  }

  /// Escucha en tiempo real la lista de tareas de un evento ordenadas por hora de inicio
  Stream<List<TaskModel>> getTasksByEvent(String eventId) {
    return _tasksCollection
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) {
      final tasks = snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
      // Ordenar localmente por horaInicio de forma amigable
      tasks.sort((a, b) => a.horaInicio.compareTo(b.horaInicio));
      return tasks;
    });
  }

  /// Actualiza únicamente el estado de una tarea ('pendiente', 'en_curso', 'completada')
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      final isCompleted = (newStatus.toLowerCase() == 'completada');
      await _tasksCollection.doc(taskId).update({
        'estado': newStatus,
        'isCompleted': isCompleted,
      });
    } catch (e) {
      throw Exception('Error al actualizar estado de la tarea: ${e.toString()}');
    }
  }

  /// Alterna el estado de una tarea cíclicamente: pendiente -> en_curso -> completada -> pendiente
  Future<void> cycleTaskStatus(TaskModel task) async {
    String nextStatus;
    switch (task.estado) {
      case 'pendiente':
        nextStatus = 'en_curso';
        break;
      case 'en_curso':
        nextStatus = 'completada';
        break;
      case 'completada':
      default:
        nextStatus = 'pendiente';
        break;
    }
    await updateTaskStatus(task.id, nextStatus);
  }

  /// Actualiza todos los campos de una tarea
  Future<void> updateTask(TaskModel task) async {
    try {
      await _tasksCollection.doc(task.id).update(task.toMap());
    } catch (e) {
      throw Exception('Error al modificar la tarea: ${e.toString()}');
    }
  }

  /// Elimina una tarea por su ID
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Error al eliminar la tarea: ${e.toString()}');
    }
  }
}
