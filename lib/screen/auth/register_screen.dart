import 'package:attendance_app/screen/auth/widgets/auth_text_field.dart';
import 'package:attendance_app/screen/auth/widgets/gradient_scaffold.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginTap;

  const RegisterScreen({super.key, required this.onLoginTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // From State = menghubungkan antara form sama key
  // Global Key = sebuah key yang unik di seluruh aplikasi flutter kita, jadi ga akan ada duplikat
  // kenapa harus ada global key dan form key? = supaya kita bisa validasi form dan mengakses state form dari widget lain
  final _emailCongtroller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthServices();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Future : function yang ga punya kembalian, makanya pakai <void>
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => 
      _isLoading = true); // jika dia sudah memvalidasi, dia akan loading

      try { // try = dijalankan kalo berhasil
        await _authService.registerWithEmailAndPassword(
          _emailCongtroller.text.trim(), // trim() = menghilangkan spasi di awal dan akhir
          _passwordController.text.trim(),
        );
      } catch (e) { // catch = dijalankan kalo ada error
        if (mounted) { // mounted = properti boolean untuk cek apakah widget masih ada di struktur widget di flutter atau ga
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()),
            backgroundColor: Colors.red,)
          );
        }
      } finally { // finally = dijalankan setelah try atau catch selesai
        if (mounted) setState(() => _isLoading = false);
      }
  }

  @override
  void dispose() {
    _emailCongtroller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      logoIcon: Icons.person_add_rounded,
      title: "Create Account",
      subtitle: "Register to get started",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
            child: Padding(padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthTextField(
                    controller: _emailCongtroller,
                    label: "Email",
                    isObscureText: false,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                      value?.isEmpty ?? true ? "Please enter your email" : null,
                  ),
                  SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock_outline,
                    isObscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.blue[600],
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword), // kalo di klik menampilkan obscure password, kalo ga di klik tidak akan menampilkan onscure password
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return "Please enter your password";
                      if (value!.length < 6) return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    icon: Icons.lock_outline,
                    isObscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.blue[600],
                      ),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return "Please confirm your password";
                      if (value != _passwordController.text) return "Passwords do not match"; // ngecek apakah password sama atau ga
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                        elevation: 4,
                    ),
                    child: _isLoading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add_rounded, size: 16),
                          Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
            ),
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: widget.onLoginTap,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white),
              child: Text("Already have an account? Log in",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ],
      ),
    );
  }
}