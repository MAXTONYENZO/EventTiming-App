import 'constants.dart';

/// Validador de entradas de formulario para EventTiming
class Validators {
  /// Expresión regular estándar para validación de formato de correo electrónico
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Valida que el correo no esté vacío y tenga un formato válido
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.errRequiredField;
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return AppConstants.errInvalidEmail;
    }
    return null;
  }

  /// Valida que la contraseña no esté vacía y tenga al menos 6 caracteres
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.errRequiredField;
    }
    if (value.trim().length < 6) {
      return AppConstants.errShortPassword;
    }
    return null;
  }

  /// Valida que la confirmación de contraseña coincida con la contraseña original
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.errRequiredField;
    }
    if (value != password) {
      return AppConstants.errPasswordMismatch;
    }
    return null;
  }

  /// Valida que un campo genérico no esté vacío
  static String? validateNotEmpty(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName es obligatorio'
          : AppConstants.errRequiredField;
    }
    return null;
  }
}
