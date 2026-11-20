import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  String selectedRole = 'siswa'; // 'siswa' or 'guru'
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

  List<Widget> _buildSiswaFields(Color primaryColor) {
    if (selectedRole != 'siswa') return [];
    return [
      const Text('NISN (10 Digit)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
      const SizedBox(height: 6),
      TextField(
        controller: nisnController,
        keyboardType: TextInputType.number,
        maxLength: 10,
        decoration: InputDecoration(
          hintText: 'Contoh: 0051234567',
          counterText: '',
          prefixIcon: Icon(Icons.badge_outlined, color: primaryColor, size: 20),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
      ),
      const SizedBox(height: 16),
      const Text('Pilih Kelas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: selectedClass,
        decoration: InputDecoration(
          hintText: 'Pilih Kelas',
          prefixIcon: Icon(Icons.class_outlined, color: primaryColor, size: 20),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
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
    const primaryColor = Color(0xFFAD8B73);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBE9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Daftar Akun Baru', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Buat Akun Netropia',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        'Isi data di bawah untuk memulai pembelajaran TKJ',
                        style: TextStyle(fontSize: 12.5, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Role Tab Selector
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
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
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.school_rounded,
                                      size: 18,
                                      color: selectedRole == 'siswa'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Siswa',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.5,
                                        color: selectedRole == 'siswa'
                                            ? Colors.white
                                            : Colors.grey.shade700,
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
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: 18,
                                      color: selectedRole == 'guru'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Guru / Pengajar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.5,
                                        color: selectedRole == 'guru'
                                            ? Colors.white
                                            : Colors.grey.shade700,
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
                    const SizedBox(height: 20),

                    // Nama Lengkap
                    const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama lengkap',
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: primaryColor, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // NISN & Kelas (Siswa)
                    ..._buildSiswaFields(primaryColor),

                    // Email
                    const Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Masukkan email',
                        prefixIcon: const Icon(Icons.email_outlined, color: primaryColor, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Minimal 6 karakter',
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: primaryColor, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 20),
                          onPressed: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi Password
                    const Text('Konfirmasi Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Ulangi password',
                        prefixIcon: const Icon(Icons.lock_clock_outlined, color: primaryColor, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 20),
                          onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: primaryColor.withOpacity(0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.person_add_rounded, size: 20),
                        label: Text(
                          isLoading ? 'Mendaftarkan...' : 'Daftar Akun Netropia',
                          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
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
