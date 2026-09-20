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

  String? selectedClass;

  final List<String> classOptions = [
    'X TKJ 1',
    'X TKJ 2',
    'X TKJ 3',
  ];

  Future<void> register() async {
    final name = nameController.text.trim();
    final nisn = nisnController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validasi nama
    if (name.isEmpty) {
      showMessage('Nama lengkap harus diisi.');
      return;
    }

    // Validasi NISN
    if (nisn.isEmpty) {
      showMessage('NISN harus diisi.');
      return;
    }

    if (nisn.length != 10 || int.tryParse(nisn) == null) {
      showMessage('NISN harus terdiri dari 10 digit angka.');
      return;
    }

    // Validasi kelas
    if (selectedClass == null) {
      showMessage('Silakan pilih kelas.');
      return;
    }

    // Validasi email
    if (email.isEmpty) {
      showMessage('Email harus diisi.');
      return;
    }

    // Validasi password
    if (password.isEmpty) {
      showMessage('Password harus diisi.');
      return;
    }

    if (password.length < 6) {
      showMessage('Password minimal 6 karakter.');
      return;
    }

    // Validasi konfirmasi password
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
      // Membuat akun Firebase Authentication
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Akun gagal dibuat.');
      }

      // Menyimpan data siswa ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'nama': name,
        'nisn': nisn,
        'kelas': selectedClass,
        'email': email,
        'role': 'siswa',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showMessage('Pendaftaran berhasil! Silakan login.');

      // Logout setelah registrasi
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      // Kembali ke halaman login
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email tersebut sudah terdaftar.';
          break;

        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;

        case 'weak-password':
          message = 'Password terlalu lemah.';
          break;

        case 'operation-not-allowed':
          message = 'Pendaftaran email/password belum diaktifkan di Firebase.';
          break;

        case 'network-request-failed':
          message = 'Tidak ada koneksi internet.';
          break;

        default:
          message = 'Pendaftaran gagal: ${e.message ?? e.code}';
      }

      if (mounted) {
        showMessage(message);
      }
    } on FirebaseException catch (e) {
      debugPrint('===== FIRESTORE ERROR =====');
      debugPrint('CODE: ${e.code}');
      debugPrint('MESSAGE: ${e.message}');
      debugPrint('===========================');

      if (mounted) {
        showMessage(
          'Gagal menyimpan data siswa: ${e.message ?? e.code}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('===== ERROR PENDAFTARAN =====');
      debugPrint('ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('=============================');

      if (mounted) {
        showMessage('Terjadi kesalahan saat pendaftaran: $e');
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
      ),
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Siswa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Icon
              const Center(
                child: Icon(
                  Icons.person_add,
                  size: 70,
                  color: Color(0xFF1565C0),
                ),
              ),

              const SizedBox(height: 20),

              // Judul
              const Center(
                child: Text(
                  'Buat Akun Siswa',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Deskripsi
              const Center(
                child: Text(
                  'Daftar untuk mulai belajar di Netropia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // NAMA LENGKAP
              // =========================
              const Text(
                'Nama Lengkap',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // NISN
              // =========================
              const Text(
                'NISN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: nisnController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: 'Masukkan 10 digit NISN',
                  prefixIcon: Icon(Icons.badge_outlined),
                  counterText: '',
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // KELAS
              // =========================
              const Text(
                'Kelas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedClass,
                decoration: const InputDecoration(
                  hintText: 'Pilih kelas',
                  prefixIcon: Icon(Icons.class_outlined),
                ),
                items: classOptions.map((String className) {
                  return DropdownMenuItem<String>(
                    value: className,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: isLoading
                    ? null
                    : (String? value) {
                  setState(() {
                    selectedClass = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              // =========================
              // EMAIL
              // =========================
              const Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Masukkan email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // PASSWORD
              // =========================
              const Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Minimal 6 karakter',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // KONFIRMASI PASSWORD
              // =========================
              const Text(
                'Konfirmasi Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Ulangi password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                        !obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // TOMBOL DAFTAR
              // =========================
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : register,
                  icon: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.person_add),
                  label: Text(
                    isLoading
                        ? 'Mendaftarkan...'
                        : 'Daftar Sekarang',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // KEMBALI KE LOGIN
              // =========================
              Center(
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Sudah punya akun? Login',
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