import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_widget.dart';
import '../widgets/task_card.dart';
import 'login_screen.dart';

/// Pantalla Principal: Timeline del Cronograma del Evento
class TimelineScreen extends StatefulWidget {
  final String? eventId;
  final String? eventTitle;

  const TimelineScreen({
    super.key,
    this.eventId,
    this.eventTitle,
  });

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late String _activeEventId;
  late String _activeEventTitle;

  @override
  void initState() {
    super.initState();
    _activeEventId = widget.eventId ?? 'evento_principal';
    _activeEventTitle = widget.eventTitle ?? 'Cronograma General';
  }

  /// Procesa el cierre de sesión seguro
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        title: const Text('Cerrar Sesión', style: AppConstants.heading3),
        content: const Text(
          '¿Estás seguro de que deseas cerrar tu sesión en EventTiming?',
          style: AppConstants.bodyTextSecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: AppConstants.secondaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  /// Despliega el formulario modal para agregar una nueva tarea
  void _showAddTaskModal() {
    final formKey = GlobalKey<FormState>();
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    final horaInicioController = TextEditingController(text: '10:00');
    final horaFinController = TextEditingController(text: '11:00');
    final proveedorController = TextEditingController();
    String estadoSeleccionado = 'pendiente';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.defaultBorderRadius * 1.5),
        ),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (modalContext, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: AppConstants.paddingLarge,
            right: AppConstants.paddingLarge,
            top: AppConstants.paddingLarge,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppConstants.paddingLarge,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título Modal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nueva Tarea de Timeline',
                        style: AppConstants.heading3,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Título
                  CustomTextField(
                    controller: tituloController,
                    labelText: 'Título de la Tarea',
                    hintText: 'Ej. Llegada del Florista / Fotografía',
                    prefixIcon: Icons.task_alt,
                    validator: (val) => Validators.validateNotEmpty(val, 'El título'),
                  ),
                  const SizedBox(height: 12),

                  // Descripción
                  CustomTextField(
                    controller: descripcionController,
                    labelText: 'Descripción / Instrucciones',
                    hintText: 'Detalles clave de la actividad...',
                    prefixIcon: Icons.description_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),

                  // Horarios en Fila
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: horaInicioController,
                          labelText: 'Hora Inicio',
                          hintText: '10:00 AM',
                          prefixIcon: Icons.schedule,
                          validator: (val) => Validators.validateNotEmpty(val, 'Hora inicio'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: horaFinController,
                          labelText: 'Hora Fin',
                          hintText: '11:00 AM',
                          prefixIcon: Icons.alarm_off,
                          validator: (val) => Validators.validateNotEmpty(val, 'Hora fin'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Proveedor Asignado
                  CustomTextField(
                    controller: proveedorController,
                    labelText: 'Proveedor o Responsable',
                    hintText: 'Ej. Florería Flores & Co / Catering',
                    prefixIcon: Icons.business_outlined,
                  ),
                  const SizedBox(height: 12),

                  // Selector de Estado
                  DropdownButtonFormField<String>(
                    initialValue: estadoSeleccionado,
                    decoration: InputDecoration(
                      labelText: 'Estado Inicial',
                      prefixIcon: const Icon(Icons.flag_outlined, color: AppConstants.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'pendiente',
                        child: Text('Pendiente (Naranja)'),
                      ),
                      DropdownMenuItem(
                        value: 'en_curso',
                        child: Text('En Curso (Azul)'),
                      ),
                      DropdownMenuItem(
                        value: 'completada',
                        child: Text('Completada (Verde)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          estadoSeleccionado = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Botón Guardar Tarea
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      final firestoreService = Provider.of<FirestoreService>(
                        context,
                        listen: false,
                      );
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      final newTask = TaskModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        eventId: _activeEventId,
                        proveedorId: proveedorController.text.trim(),
                        titulo: tituloController.text.trim(),
                        descripcion: descripcionController.text.trim(),
                        horaInicio: horaInicioController.text.trim(),
                        horaFin: horaFinController.text.trim(),
                        estado: estadoSeleccionado,
                        isCompleted: estadoSeleccionado == 'completada',
                      );

                      try {
                        await firestoreService.createTask(newTask);
                        // Disparar aviso con NotificationService
                        NotificationService().notifyTaskStatusChange(
                          taskTitle: newTask.titulo,
                          newStatus: newTask.estado,
                        );

                        if (ctx.mounted) {
                          Navigator.of(ctx).pop();
                        }
                        if (mounted) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Tarea creada exitosamente'),
                              backgroundColor: AppConstants.statusCompletedColor,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text('Error al guardar: ${e.toString()}'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.add_task, color: Colors.white),
                    label: const Text('Agregar a la Timeline', style: AppConstants.buttonText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timeline del Evento',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Colors.white,
              ),
            ),
            Text(
              _activeEventTitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: AppConstants.primaryColor,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Cerrar Sesión',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: firestoreService.getTasksByEvent(_activeEventId),
        builder: (context, snapshot) {
          // Estado de Carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Cargando timeline...');
          }

          // Estado de Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    const Text('Error al cargar el cronograma', style: AppConstants.heading3),
                    const SizedBox(height: 6),
                    Text(
                      snapshot.error.toString(),
                      style: AppConstants.bodyTextSecondary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final tasks = snapshot.data ?? [];

          // Estado Vacío
          if (tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.timeline,
                        size: 64,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No hay tareas programadas',
                      style: AppConstants.heading2,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Comienza agregando las actividades e hitos del evento para mantener a todos coordinados.',
                      style: AppConstants.bodyTextSecondary,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingLarge,
                          vertical: AppConstants.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                        ),
                      ),
                      onPressed: _showAddTaskModal,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Agregar Primera Tarea', style: AppConstants.buttonText),
                    ),
                  ],
                ),
              ),
            );
          }

          // Lista de Tareas
          return ListView.builder(
            padding: const EdgeInsets.only(
              top: AppConstants.paddingMedium,
              bottom: 80, // Espacio para el FAB
            ),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onToggleStatus: () async {
                  await firestoreService.cycleTaskStatus(task);
                },
                onDelete: () async {
                  await firestoreService.deleteTask(task.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tarea eliminada'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.primaryColor,
        onPressed: _showAddTaskModal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nueva Tarea', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
