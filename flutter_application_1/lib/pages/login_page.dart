import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // untuk mengecek isian form
  final _emailController = TextEditingController(); // isi kolom email
  final _passwordController = TextEditingController(); // isi kolom password
  bool _hidePassword = true; // true = password disamarkan

  Future<void> _login() async {
    // Jika ada kolom yang tidak valid, berhenti di sini.
    if (!_formKey.currentState!.validate()) return;

    // Simpan email ke SharedPreferences sebagai tanda sudah login.
    final email = _emailController.text.trim();
    await StorageService.saveEmail(email);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage(email: email)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.storefront,
                    size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 8),
                const Text('DascoKorup Mart',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Text('Masuk untuk mulai belanja'),
                const SizedBox(height: 32),

                // Kolom email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null; // null = valid
                  },
                ),
                const SizedBox(height: 16),

                // Kolom password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(_hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        // setState = gambar ulang layar karena data berubah
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _login,
                    child: const Text('Masuk'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
