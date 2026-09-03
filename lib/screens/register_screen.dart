import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_widget.dart';
import 'timeline_screen.dart';

/// Pantalla de Registro de Nuevos Usuarios
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'planner'; // 'planner', 'proveedor', 'novio'
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Procesa la creación de cuenta en Firebase
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.registerWithEmail(
        _emailController.text,
        _passwordController.text,
        nombre: _nombreController.text.trim(),
        rol: _selectedRole,
      );

      if (user != null && mounted) {
        // Redirige al TimelineScreen tras registro exitoso
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const TimelineScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Crear Cuenta', style: TextStyle(color: AppConstants.textPrimaryColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppConstants.textPrimaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Únete a EventTiming',
                    style: AppConstants.heading1,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Organiza cronogramas de eventos de forma impecable.',
                    style: AppConstants.bodyTextSecondary,
                  ),
                  const SizedBox(height: 24),

                  // Mensaje de Error
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingSmall + 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Campo Nombre Completo
                  CustomTextField(
                    controller: _nombreController,
                    labelText: 'Nombre Completo',
                    hintText: 'Ej. Laura González',
                    prefixIcon: Icons.person_outline,
                    validator: (v) => Validators.validateNotEmpty(v, 'El nombre'),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Selector de Rol
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRole,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: AppConstants.primaryColor),
                        items: const [
                          DropdownMenuItem(
                            value: 'planner',
                            child: Row(
                              children: [
                                Icon(Icons.event_note, color: AppConstants.primaryColor, size: 20),
                                SizedBox(width: 10),
                                Text('Wedding / Event Planner'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'proveedor',
                            child: Row(
                              children: [
                                Icon(Icons.handshake, color: AppConstants.primaryColor, size: 20),
                                SizedBox(width: 10),
                                Text('Proveedor de Servicios'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'novio',
                            child: Row(
                              children: [
                                Icon(Icons.favorite_border, color: AppConstants.primaryColor, size: 20),
                                SizedBox(width: 10),
                                Text('Novio / Anfitrión'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: _isLoading
                            ? null
                            : (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedRole = val;
                                  });
                                }
                              },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo Correo Electrónico
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Correo Electrónico',
                    hintText: 'ejemplo@correo.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Campo Contraseña
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    hintText: 'Mínimo 6 caracteres',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.validatePassword,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Campo Confirmar Contraseña
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirmar Contraseña',
                    hintText: 'Repite tu contraseña',
                    prefixIcon: Icons.lock_reset,
                    isPassword: true,
                    validator: (val) => Validators.validateConfirmPassword(
                      val,
                      _passwordController.text,
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Indicador de carga o Botón Crear Cuenta
                  _isLoading
                      ? const LoadingWidget(message: 'Creando cuenta...')
                      : ElevatedButton(
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
                            elevation: 2,
                          ),
                          onPressed: _handleRegister,
                          child: const Text(
                            'Crear Cuenta',
                            style: AppConstants.buttonText,
                          ),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
