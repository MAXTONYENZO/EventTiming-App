import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

/// Tarjeta para visualizar y gestionar una tarea del cronograma
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggleStatus;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleStatus,
    this.onDelete,
  });

  /// Color principal según el estado de la tarea
  Color _getStatusColor() {
    switch (task.estado.toLowerCase()) {
      case 'en_curso':
        return AppConstants.statusInProgressColor;
      case 'completada':
        return AppConstants.statusCompletedColor;
      case 'pendiente':
      default:
        return AppConstants.statusPendingColor;
    }
  }

  /// Color de fondo sutil según el estado
  Color _getBackgroundColor() {
    switch (task.estado.toLowerCase()) {
      case 'en_curso':
        return const Color(0xFFE3F2FD); // Azul muy claro
      case 'completada':
        return const Color(0xFFE8F5E9); // Verde muy claro
      case 'pendiente':
      default:
        return const Color(0xFFFFF3E0); // Naranja muy claro
    }
  }

  /// Ícono representativo del estado
  IconData _getStatusIcon() {
    switch (task.estado.toLowerCase()) {
      case 'en_curso':
        return Icons.play_circle_filled_rounded;
      case 'completada':
        return Icons.check_circle_rounded;
      case 'pendiente':
      default:
        return Icons.schedule_rounded;
    }
  }

  /// Etiqueta legible del estado
  String _getStatusLabel() {
    switch (task.estado.toLowerCase()) {
      case 'en_curso':
        return 'En Curso';
      case 'completada':
        return 'Completada';
      case 'pendiente':
      default:
        return 'Pendiente';
    }
  }

  /// Muestra el modal con los detalles completos de la tarea
  void _showDetailsDialog(BuildContext context) {
    final statusColor = _getStatusColor();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        title: Row(
          children: [
            Icon(_getStatusIcon(), color: statusColor, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.titulo,
                style: AppConstants.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Estado Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Estado: ${_getStatusLabel()}',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Horario
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: AppConstants.secondaryColor),
                  const SizedBox(width: 6),
                  Text(
                    '${task.horaInicio} - ${task.horaFin}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Descripción
              const Text(
                'Descripción:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.textSecondaryColor),
              ),
              const SizedBox(height: 4),
              Text(
                task.descripcion.isNotEmpty
                    ? task.descripcion
                    : 'Sin descripción detallada.',
                style: AppConstants.bodyText,
              ),

              if (task.proveedorId.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 18, color: AppConstants.secondaryColor),
                    const SizedBox(width: 6),
                    Text(
                      'Proveedor: ${task.proveedorId}',
                      style: AppConstants.caption,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (onDelete != null)
            TextButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                onDelete!();
              },
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              label: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
            ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              onToggleStatus();
            },
            icon: const Icon(Icons.swap_horiz, color: Colors.white, size: 18),
            label: const Text('Cambiar Estado', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final bgColor = _getBackgroundColor();

    return Card(
      elevation: AppConstants.cardElevation,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        side: BorderSide(color: statusColor.withValues(alpha: 0.4), width: 1.2),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        onTap: () => _showDetailsDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador visual de estado
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getStatusIcon(), color: statusColor, size: 24),
              ),
              const SizedBox(width: 14),

              // Contenido de la tarea
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la tarea (negrita)
                    Text(
                      task.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Descripción (subtítulo)
                    if (task.descripcion.isNotEmpty) ...[
                      Text(
                        task.descripcion,
                        style: AppConstants.bodyTextSecondary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                    ],

                    // Horario y Estado Chip
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          size: 14,
                          color: AppConstants.secondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${task.horaInicio} - ${task.horaFin}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getStatusLabel(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Botón rápido para cambiar estado
              IconButton(
                icon: const Icon(Icons.sync, size: 22),
                color: statusColor,
                tooltip: 'Cambiar estado',
                onPressed: onToggleStatus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
