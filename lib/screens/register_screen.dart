import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  String selectedRole = 'siswa';
  String? selectedClass;

  final List<String> classOptions = [
    'X TKJ 1',
    'X TKJ 2',
    'X TKJ 3',
    'Guru TKJ',
  ];

  Future<void> register() async {
    final name = nameController.text.trim();
    final nisn = nisnController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty) {
      showMessage('Nama lengkap harus diisi.');
      return;
    }

    if (selectedRole == 'siswa') {
      if (nisn.isEmpty) {
        showMessage('NISN harus diisi.');
        return;
      }
      if (nisn.length != 10 || int.tryParse(nisn) == null) {
        showMessage('NISN harus terdiri dari 10 digit angka.');
        return;
      }
      if (selectedClass == null) {
        showMessage('Silakan pilih kelas.');
        return;
      }
    }

    if (email.isEmpty) {
      showMessage('Email harus diisi.');
      return;
    }

    if (password.isEmpty) {
      showMessage('Password harus diisi.');
      return;
    }

    if (password.length < 6) {
      showMessage('Password minimal 6 karakter.');
      return;
    }

    if (confirmPassword.isEmpty) {
      showMessage('Konfirmasi password harus diisi.');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Konfirmasi password tidak cocok.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Gagal membuat akun.');
      }

      await user.updateDisplayName(name);

      final userData = {
        'uid': user.uid,
        'nama': name,
        'email': email,
        'role': selectedRole,
        'nisn': selectedRole == 'siswa' ? nisn : '-',
        'kelas': selectedRole == 'siswa' ? (selectedClass ?? 'X TKJ 1') : 'Guru TKJ',
        'photoUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData);

      if (!mounted) return;

      showMessage('Pendaftaran berhasil! Silakan masuk ke akun Anda.');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email ini sudah terdaftar. Gunakan email lain atau langsung login.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'weak-password':
          message = 'Password terlalu lemah. Gunakan minimal 6 karakter.';
          break;
        case 'network-request-failed':
          message = 'Tidak dapat terhubung ke internet.';
          break;
        default:
          message = 'Pendaftaran gagal: ${e.message ?? e.code}';
      }
      if (mounted) {
        showMessage(message);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        showMessage('Terjadi masalah pada database: ${e.message}');
      }
    } catch (e) {
      if (mounted) {
        showMessage('Terjadi kesalahan saat pendaftaran.');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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

  List<Widget> _buildSiswaFields(bool isDark) {
    if (selectedRole != 'siswa') return [];
    return [
      Text('NISN (10 Digit)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : AppTheme.textDark)),
      const SizedBox(height: 6),
      TextField(
        controller: nisnController,
        keyboardType: TextInputType.number,
        maxLength: 10,
        style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
        decoration: InputDecoration(
          hintText: 'Contoh: 0051234567',
          counterText: '',
          prefixIcon: const Icon(Icons.badge_outlined, color: AppTheme.primaryTeal, size: 20),
          filled: true,
          fillColor: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(height: 16),
      Text('Pilih Kelas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : AppTheme.textDark)),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: selectedClass,
        style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
        dropdownColor: Theme.of(context).cardColor,
        decoration: InputDecoration(
          hintText: 'Pilih Kelas',
          prefixIcon: const Icon(Icons.class_outlined, color: AppTheme.primaryTeal, size: 20),
          filled: true,
          fillColor: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
        items: classOptions
            .where((c) => c != 'Guru TKJ')
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: (val) {
          if (val != null) setState(() => selectedClass = val);
        },
      ),
      const SizedBox(height: 16),
    ];
  }

  @override
  void dispose() {
    nameController.dispose();
    nisnController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Daftar Akun Baru', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Buat Akun Netropia',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryTeal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        'Isi data di bawah untuk memulai pembelajaran TKJ',
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Role Tab Selector
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRole = 'siswa';
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selectedRole == 'siswa'
                                      ? AppTheme.primaryTeal
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.school_rounded,
                                      size: 17,
                                      color: selectedRole == 'siswa'
                                          ? Colors.white
                                          : AppTheme.textMuted,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Siswa',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: selectedRole == 'siswa'
                                            ? Colors.white
                                            : AppTheme.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRole = 'guru';
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selectedRole == 'guru'
                                      ? AppTheme.primaryTeal
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: 17,
                                      color: selectedRole == 'guru'
                                          ? Colors.white
                                          : AppTheme.textMuted,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Guru / Pengajar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: selectedRole == 'guru'
                                            ? Colors.white
                                            : AppTheme.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Nama Lengkap
                    Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : AppTheme.textDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama lengkap',
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: AppTheme.primaryTeal, size: 20),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // NISN & Kelas (Siswa)
                    ..._buildSiswaFields(isDark),

                    // Email
                    Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : AppTheme.textDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
                      decoration: InputDecoration(
                        hintText: 'Masukkan email',
                        prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.primaryTeal, size: 20),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : AppTheme.textDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
                      decoration: InputDecoration(
                        hintText: 'Minimal 6 karakter',
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppTheme.primaryTeal, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.textMuted, size: 20),
                          onPressed: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi Password
                    Text('Konfirmasi Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : AppTheme.textDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
                      decoration: InputDecoration(
                        hintText: 'Ulangi password',
                        prefixIcon: const Icon(Icons.lock_clock_outlined, color: AppTheme.primaryTeal, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.textMuted, size: 20),
                          onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.person_add_rounded, size: 20),
                        label: Text(
                          isLoading ? 'Mendaftarkan...' : 'Daftar Akun Netropia',
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
