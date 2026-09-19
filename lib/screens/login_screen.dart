import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;
  bool rememberMe = false;

  String selectedRole = 'siswa';

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('saved_email') ?? '';
      passwordController.text = prefs.getString('saved_password') ?? '';
      rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password', password);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Email dan password harus diisi.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Data pengguna tidak ditemukan.');
      }

      final DocumentSnapshot userDocument =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDocument.exists) {
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          showMessage(
            'Profil pengguna belum ditemukan di database.',
          );
        }

        return;
      }

      final data =
      userDocument.data() as Map<String, dynamic>;

      final String role =
      (data['role'] ?? '').toString().toLowerCase().trim();

      final String nama =
      (data['nama'] ??
          user.displayName ??
          user.email ??
          'Pengguna')
          .toString();

      if (role != selectedRole) {
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          showMessage(
            'Akun ini terdaftar sebagai '
                '${role.isEmpty ? 'pengguna' : role}, '
                'bukan sebagai $selectedRole.',
          );
        }

        return;
      }

      if (!mounted) return;

      await _saveCredentials(email, password);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            username: nama,
            role: role,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-credential':
          message = 'Email atau password salah.';
          break;

        case 'user-not-found':
          message = 'Akun dengan email tersebut belum terdaftar.';
          break;

        case 'wrong-password':
          message = 'Password yang dimasukkan salah.';
          break;

        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;

        case 'user-disabled':
          message = 'Akun ini telah dinonaktifkan.';
          break;

        case 'too-many-requests':
          message =
          'Terlalu banyak percobaan login. Coba lagi beberapa saat.';
          break;

        case 'network-request-failed':
          message = 'Tidak dapat terhubung ke internet.';
          break;

        default:
          message =
          'Login gagal: ${e.message ?? e.code}';
      }

      if (mounted) {
        showMessage(message);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        showMessage(
          'Terjadi masalah pada database: ${e.message}',
        );
      }
    } catch (e) {
      if (mounted) {
        showMessage('Terjadi kesalahan saat login.');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // LUPA PASSWORD
  // ============================================================

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage(
        'Masukkan email terlebih dahulu.',
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (mounted) {
        showMessage(
          'Email reset password telah dikirim. '
              'Silakan cek email Anda.',
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;

        case 'user-not-found':
          message = 'Email tersebut belum terdaftar.';
          break;

        default:
          message =
          'Gagal mengirim email reset password.';
      }

      if (mounted) {
        showMessage(message);
      }
    }
  }

  // ============================================================
  // PESAN
  // ============================================================

  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            30,
            24,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // LOGO
              // ==================================================

              Center(
                child: Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                    BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.blue.withOpacity(0.20),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Center(
                child: Text(
                  'NETROPIA',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              const Center(
                child: Text(
                  'Interactive TKJ Learning',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // LOGIN CARD
              // ==================================================

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    // LOGIN SEBAGAI
                    const Text(
                      'Login sebagai',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _roleButton(
                            title: 'Siswa',
                            icon: Icons.school_rounded,
                            selected:
                            selectedRole == 'siswa',
                            onTap: () {
                              setState(() {
                                selectedRole = 'siswa';
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _roleButton(
                            title: 'Guru',
                            icon: Icons.person_rounded,
                            selected:
                            selectedRole == 'guru',
                            onTap: () {
                              setState(() {
                                selectedRole = 'guru';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // EMAIL
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: emailController,
                      keyboardType:
                      TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Masukkan email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        filled: true,
                        fillColor:
                        const Color(0xFFF7F9FC),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide:
                          const BorderSide(
                            color: Color(0xFF1565C0),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // PASSWORD
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      onSubmitted: (_) {
                        if (!isLoading) {
                          login();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword =
                              !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        filled: true,
                        fillColor:
                        const Color(0xFFF7F9FC),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide:
                          const BorderSide(
                            color: Color(0xFF1565C0),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    // ==================================================
                    // LUPA PASSWORD
                    // ==================================================

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed:
                        isLoading
                            ? null
                            : forgotPassword,
                        style: TextButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // INGAT SAYA
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: rememberMe,
                            onChanged: (val) {
                              setState(() {
                                rememberMe = val ?? false;
                              });
                            },
                            activeColor: const Color(0xFF1565C0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Ingat Saya',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF172033),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ==================================================
                    // BUTTON LOGIN
                    // ==================================================

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                        isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                            ),
                            SizedBox(width: 9),
                            Text(
                              'Masuk ke Netropia',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // DAFTAR SISWA
              // ==================================================

              if (selectedRole == 'siswa')
                Center(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      TextButton(
                        onPressed:
                        isLoading
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                              const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar sekarang',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ==================================================
              // INFO GURU
              // ==================================================

              if (selectedRole == 'guru')
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius:
                    BorderRadius.circular(14),
                    border: Border.all(
                      color:
                      const Color(0xFFFFE082),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFF57C00),
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Akun guru dibuat oleh administrator. '
                              'Silakan gunakan akun guru yang telah diberikan.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 25),

              // ==================================================
              // FOOTER
              // ==================================================

              const Center(
                child: Text(
                  'Netropia • Pembelajaran TKJ SMK Kelas X',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ROLE BUTTON
  // ============================================================

  Widget _roleButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1565C0)
              : const Color(0xFFF7F9FC),
          borderRadius:
          BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF1565C0)
                : const Color(0xFFE1E5EA),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? Colors.white
                  : const Color(0xFF1565C0),
            ),

            const SizedBox(width: 7),

            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}