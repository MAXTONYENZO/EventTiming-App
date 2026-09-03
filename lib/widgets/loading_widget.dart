import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Widget reutilizable para mostrar un indicador de carga circular centrado con mensaje opcional
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppConstants.primaryColor,
            ),
          ),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              message!,
              style: AppConstants.bodyTextSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
