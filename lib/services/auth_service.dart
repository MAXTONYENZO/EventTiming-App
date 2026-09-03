import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

/// Servicio de Autenticación de Firebase y gestión de tokens seguros
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FlutterSecureStorage _secureStorage;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FlutterSecureStorage? secureStorage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Stream reactivo de cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuario actualmente autenticado
  User? get currentUser => _auth.currentUser;

  /// Inicia sesión con correo electrónico y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user != null) {
        // Almacenar token JWT y UID en almacenamiento cifrado seguro
        final token = await user.getIdToken();
        if (token != null) {
          await _secureStorage.write(
            key: AppConstants.storageTokenKey,
            value: token,
          );
        }
        await _secureStorage.write(
          key: AppConstants.storageUserUidKey,
          value: user.uid,
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  /// Registra una nueva cuenta con correo, contraseña y datos de perfil
  Future<User?> registerWithEmail(
    String email,
    String password, {
    String nombre = '',
    String rol = 'planner',
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user != null) {
        // Crear documento del usuario en Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: email.trim(),
          nombre: nombre.trim().isNotEmpty ? nombre.trim() : email.split('@').first,
          rol: rol,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        // Guardar token y rol en flutter_secure_storage
        final token = await user.getIdToken();
        if (token != null) {
          await _secureStorage.write(
            key: AppConstants.storageTokenKey,
            value: token,
          );
        }
        await _secureStorage.write(
          key: AppConstants.storageUserUidKey,
          value: user.uid,
        );
        await _secureStorage.write(
          key: AppConstants.storageUserRoleKey,
          value: rol,
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error al registrar usuario: ${e.toString()}');
    }
  }

  /// Cierra la sesión activa y limpia las credenciales del almacenamiento seguro
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _secureStorage.delete(key: AppConstants.storageTokenKey);
      await _secureStorage.delete(key: AppConstants.storageUserUidKey);
      await _secureStorage.delete(key: AppConstants.storageUserRoleKey);
    } catch (e) {
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }

  /// Envía un correo de restablecimiento de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error al enviar correo de recuperación: ${e.toString()}');
    }
  }

  /// Obtiene el token seguro almacenado
  Future<String?> getSavedToken() async {
    return await _secureStorage.read(key: AppConstants.storageTokenKey);
  }

  /// Traduce los códigos de error de FirebaseAuth a mensajes comprensibles en español
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No se encontró ningún usuario con este correo electrónico.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Credenciales incorrectas. Verifica tu correo y contraseña.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta registrada con este correo electrónico.';
      case 'invalid-email':
        return 'El formato de correo electrónico proporcionado no es válido.';
      case 'weak-password':
        return 'La contraseña ingresada es demasiado débil (mínimo 6 caracteres).';
      case 'user-disabled':
        return 'Esta cuenta de usuario ha sido inhabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Por favor, intenta de nuevo más tarde.';
      case 'network-request-failed':
        return 'Error de conexión a internet. Revisa tu red y vuelve a intentar.';
      default:
        return e.message ?? AppConstants.errGeneric;
    }
  }
}
