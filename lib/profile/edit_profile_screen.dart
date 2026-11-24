import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  final String username;
  final String role;
  const EditProfileScreen({super.key, required this.username, required this.role});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  bool _isUploading = false;
  final user = FirebaseAuth.instance.currentUser;

  String? _selectedClass;

  final List<String> _classOptions = [
    'X TKJ 1',
    'X TKJ 2',
    'X TKJ 3',
    'XI TKJ 1',
    'XI TKJ 2',
    'XI TKJ 3',
    'XII TKJ 1',
    'XII TKJ 2',
    'XII TKJ 3',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.username);
    _loadUserClass();
  }

  Future<void> _loadUserClass() async {
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
        if (doc.exists) {
          final data = doc.data() ?? {};
          if (mounted) {
            setState(() {
              final k = data['kelas']?.toString();
              if (k != null && _classOptions.contains(k)) {
                _selectedClass = k;
              } else {
                _selectedClass = 'X TKJ 1';
              }
            });
          }
        }
      } catch (_) {}
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _saveChanges() async {
    if (user == null) return;

    setState(() => _isUploading = true);

    try {
      String? photoUrl = user?.photoURL;

      if (_pickedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profiles')
            .child('${user!.uid}.jpg');

        if (kIsWeb) {
          await storageRef.putData(await _pickedImage!.readAsBytes());
        } else {
          await storageRef.putFile(File(_pickedImage!.path));
        }

        photoUrl = await storageRef.getDownloadURL();
      }

      await user!.updateDisplayName(_nameController.text.trim());
      if (photoUrl != null) {
        await user!.updatePhotoURL(photoUrl);
      }

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'nama': _nameController.text.trim(),
        if (_selectedClass != null) 'kelas': _selectedClass,
        if (photoUrl != null) 'photoUrl': photoUrl,
      });

      await user!.reload();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil dan kelas berhasil diperbarui!")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui profil: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryTeal, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _pickedImage != null
                          ? (kIsWeb
                              ? NetworkImage(_pickedImage!.path)
                              : FileImage(File(_pickedImage!.path)) as ImageProvider)
                          : (user?.photoURL != null ? NetworkImage(user!.photoURL!) : null),
                      child: _pickedImage == null && user?.photoURL == null
                          ? const Icon(Icons.person_rounded, size: 70, color: AppTheme.primaryTeal)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        backgroundColor: AppTheme.primaryTeal,
                        radius: 18,
                        child: Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                prefixIcon: const Icon(Icons.person_outline_rounded, color: AppTheme.primaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.role.toLowerCase() == 'siswa') ...[
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: InputDecoration(
                  labelText: "Kelas TKJ",
                  prefixIcon: const Icon(Icons.school_rounded, color: AppTheme.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                items: _classOptions.map((k) {
                  return DropdownMenuItem(
                    value: k,
                    child: Text(k),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedClass = val);
                },
              ),
              const SizedBox(height: 20),
            ],
            TextField(
              controller: TextEditingController(text: widget.role),
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                labelText: "Role (Tidak dapat diubah)",
                prefixIcon: const Icon(Icons.work_outline_rounded, color: AppTheme.primaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
