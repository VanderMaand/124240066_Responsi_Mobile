// =====================================================================
// FILE   : lib/pages/login_page.dart
// FUNGSI : Halaman login. Username bebas, password HARUS sama dengan
//          AppConfig.loginPassword (NIM).
// [REF]  setelah sukses -> MainPage (main_page.dart); session disimpan
//        lewat services/session_service.dart
// =====================================================================

import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/session_service.dart';
import 'main_page.dart';

// StatefulWidget = widget yang tampilannya bisa berubah (misal ikon mata password).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // "kunci" untuk memicu validasi form
  final _usernameC = TextEditingController(); // pengendali isi kolom username
  final _passwordC = TextEditingController(); // pengendali isi kolom password
  bool _hidePassword = true; // true = password disamarkan ****

  // [FUNGSI] dispose : bersih-bersih controller saat halaman ditutup (cegah memory leak).
  @override
  void dispose() {
    _usernameC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  // [FUNGSI] _login : dijalankan saat tombol Login ditekan.
  Future<void> _login() async {
    // 1) Validasi kolom (tidak boleh kosong). Jika gagal -> berhenti.
    if (!_formKey.currentState!.validate()) return;

    // 2) Cek password = NIM.
    if (_passwordC.text != AppConfig.loginPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Password salah! Gunakan NIM kamu.')), // [HARDCODE] pesan error
      );
      return;
    }

    // 3) Simpan username sebagai session.
    final username = _usernameC.text.trim(); // trim = buang spasi di awal/akhir
    await SessionService.saveUsername(username);

    // 4) Pindah ke halaman utama. "mounted" = pastikan halaman masih aktif setelah await.
    if (!mounted) return;
    Navigator.pushReplacement(
      // pushReplacement = ganti halaman (tombol back TIDAK kembali ke login)
      context,
      MaterialPageRoute(builder: (_) => MainPage(username: username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          // agar bisa di-scroll saat keyboard muncul
          padding: const EdgeInsets.all(24), // jarak dalam
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.storefront,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary), // logo
                const SizedBox(height: 8), // jarak vertikal
                Text(AppConfig.appName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                // ---- Kolom username ----
                TextFormField(
                  controller: _usernameC,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Email tidak boleh kosong'
                      : null, // null = valid
                ),
                const SizedBox(height: 16),
                // ---- Kolom password ----
                TextFormField(
                  controller: _passwordC,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      // setState = beri tahu Flutter agar menggambar ulang tampilan
                      onPressed: () =>
                          setState(() => _hidePassword = !_hidePassword),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Password tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, // tombol selebar layar
                  child: FilledButton(
                    onPressed: _login,
                    child: const Text('Login'),
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
