import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services/firebase_auth_provider.dart';
import '../widgets/background_container.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogIn;
  const AuthScreen({this.isLogIn = true, super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLogIn;
  bool _obscurePassText = true;
  bool _obscureConfirmedPassText = true;
  String? errorMsg;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLogIn = widget.isLogIn;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleAuthAction() => setState(() => _isLogIn = !_isLogIn);
  void _togglePassVisibility() => setState(() => _obscurePassText = !_obscurePassText);
  void _toggleConfirmedPassVisibility() => setState(() => _obscureConfirmedPassText = !_obscureConfirmedPassText);
  void _setError(String? message) => setState(() => errorMsg = message);
  void _setLoading(bool isLoading) => setState(() => _isLoading = isLoading);

  void _forgotPassword() async {
    _setError(null);
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      _setError("Digite seu email primeiro para solicitar mudança de senha.");
      return;
    }

    _setLoading(true);
    final String? anyErrors = await context.read<FirebaseAuthProvider>().updatePasswordViaEmail(email);
    _setLoading(false);
    
    if (anyErrors != null) {
      _setError(anyErrors);
      return;
    }
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Foi enviado um email para alterar a senha. Cheque seu email."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirm(BuildContext context) async {
    _setError(null);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmedPassword = _confirmPasswordController.text.trim();

    if (!_isDataValidated(email, password, confirmedPassword)) return;

    _setLoading(true);
    if (_isLogIn) {
      String? error = await context.read<FirebaseAuthProvider>().loginEmailPassword(email, password);
      _setLoading(false);
      if (error != null) {
        _setError(error);
      } else {
        Navigator.of(context).pop();
      }
    } else {
      String? error = await context.read<FirebaseAuthProvider>().createEmailPasswordAccount(email, password);
      _setLoading(false);
      if (error != null) {
        _setError(error);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  bool _isDataValidated(String email, String password, String confirmedPassword) {
    if (email.isEmpty || password.isEmpty) {
      _setError("Email e senha são obrigatórios.");
      return false;
    }

    if (password.length < 6) {
      _setError("A senha deve ter pelo menos 6 caracteres.");
      return false;
    }

    if (!_isLogIn && password != confirmedPassword) {
      _setError("As senhas são diferentes.");
      return false;
    }

    return true;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
        obscureText: isPassword ? obscureText : false,
        keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      _isLogIn ? "Entrar" : "Crie sua conta",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogIn ? "Não possui uma conta? " : "Já possui uma conta? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: _toggleAuthAction,
                          child: Text(
                            _isLogIn ? "Criar conta" : "Fazer login",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: _emailController,
                      label: "Insira seu email",
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Insira sua senha",
                      isPassword: true,
                      obscureText: _obscurePassText,
                      onToggleVisibility: _togglePassVisibility,
                    ),
                    if (!_isLogIn)
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: "Confirmar senha",
                        isPassword: true,
                        obscureText: _obscureConfirmedPassText,
                        onToggleVisibility: _toggleConfirmedPassVisibility,
                      ),
                    if (_isLogIn)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgotPassword,
                          child: Text(
                            "Esqueceu sua senha?",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (errorMsg != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[300]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                errorMsg!,
                                style: TextStyle(color: Colors.red[300]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _confirm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          _isLogIn ? "Entrar" : "Criar conta",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
