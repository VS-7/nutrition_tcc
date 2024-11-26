import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services/firebase_auth_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogIn ? "Entre na sua conta" : "Crie uma nova conta",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Ou "),
                    TextButton(
                      onPressed: _toggleAuthAction,
                      child: Text(_isLogIn ? "crie uma nova conta" : "entre na sua conta"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassText ? Icons.visibility_off : Icons.visibility),
                      onPressed: _togglePassVisibility,
                    ),
                  ),
                  obscureText: _obscurePassText,
                ),
                if (!_isLogIn) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "Confirmar Senha",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmedPassText ? Icons.visibility_off : Icons.visibility),
                        onPressed: _toggleConfirmedPassVisibility,
                      ),
                    ),
                    obscureText: _obscureConfirmedPassText,
                  ),
                ],
                if (_isLogIn)
                  TextButton(
                    onPressed: _forgotPassword,
                    child: const Text("Esqueceu sua senha?"),
                  ),
                if (errorMsg != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMsg!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _confirm(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(_isLogIn ? "Entrar" : "Criar"),
                ),
              ],
            ),
          ),
    );
  }
}
