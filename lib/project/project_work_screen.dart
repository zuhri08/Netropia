import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class ProjectWorkScreen extends StatefulWidget {
  final String projectTitle;

  const ProjectWorkScreen({
    super.key,
    this.projectTitle = 'Membangun LAN Sederhana',
  });

  @override
  State<ProjectWorkScreen> createState() => _ProjectWorkScreenState();
}

class _ProjectWorkScreenState extends State<ProjectWorkScreen> {
  int currentStep = 0;
  bool _isSubmitting = false;

  XFile? _pickedFile;
  String? _base64File;
  String? _fileName;

  final List<bool> practiceChecklist = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  final TextEditingController problemController = TextEditingController();
  final TextEditingController planningController = TextEditingController();
  final TextEditingController testingController = TextEditingController();
  final TextEditingController reflectionController = TextEditingController();

  String selectedTopology = 'Star';

  final List<String> topologies = [
    'Star',
    'Bus',
    'Ring',
    'Mesh',
  ];

  final List<ProjectStep> steps = const [
    ProjectStep(
      title: 'Memahami Masalah',
      icon: Icons.lightbulb_outline_rounded,
    ),
    ProjectStep(
      title: 'Membuat Perencanaan',
      icon: Icons.edit_note_rounded,
    ),
    ProjectStep(
      title: 'Melakukan Praktik',
      icon: Icons.build_rounded,
    ),
    ProjectStep(
      title: 'Menguji Jaringan',
      icon: Icons.network_check_rounded,
    ),
    ProjectStep(
      title: 'Membuat Refleksi & Unggah Foto',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  Future<void> _pickProjectFile() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Str = base64Encode(bytes);
      setState(() {
        _pickedFile = image;
        _fileName = image.name;
        _base64File = 'data:image/jpeg;base64,$base64Str';
      });
    }
  }

  Future<void> _submitProjectToFirestore() async {
    setState(() => _isSubmitting = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final userData = userDoc.data() ?? {};
        final namaSiswa = userData['nama']?.toString() ?? 'Siswa';
        final kelasSiswa = userData['kelas']?.toString() ?? 'X TKJ 1';

        final docRef = FirebaseFirestore.instance.collection('project_submissions').doc();

        await docRef.set({
          'id': docRef.id,
          'projectTitle': widget.projectTitle,
          'topologi': selectedTopology,
          'siswaId': user.uid,
          'siswaName': namaSiswa,
          'kelas': kelasSiswa,
          'problem': problemController.text.trim(),
          'planning': planningController.text.trim(),
          'testing': testingController.text.trim(),
          'reflection': reflectionController.text.trim(),
          'fileUrl': _base64File,
          'fileName': _fileName,
          'nilai': null,
          'catatanGuru': null,
          'submittedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error submitting project: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    problemController.dispose();
    planningController.dispose();
    testingController.dispose();
    reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / steps.length;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pengerjaan Project',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildProgressHeader(progress, isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: _buildCurrentStep(isDark),
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(double progress, bool isDark) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.projectTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
              ),
              Text(
                '${currentStep + 1}/${steps.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppTheme.borderCream,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryTeal),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tahap ${currentStep + 1}: ${steps[currentStep].title}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(bool isDark) {
    switch (currentStep) {
      case 0:
        return _buildProblemStep(isDark);
      case 1:
        return _buildPlanningStep(isDark);
      case 2:
        return _buildPracticeStep(isDark);
      case 3:
        return _buildTestingStep(isDark);
      case 4:
        return _buildReflectionStep(isDark);
      default:
        return const SizedBox();
    }
  }

  Widget _buildProblemStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.lightbulb_outline_rounded,
          title: 'Memahami Masalah',
          subtitle: 'Pahami tantangan sebelum mulai mengerjakan project.',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Tantangan Project',
          icon: Icons.flag_outlined,
          child: const Text(
            'Sebuah ruangan memiliki beberapa komputer yang belum '
                'terhubung dalam jaringan. Kamu diminta merancang dan '
                'membangun LAN sederhana agar komputer dapat saling '
                'berkomunikasi.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: AppTheme.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildInputCard(
          title: 'Tuliskan pemahamanmu',
          controller: problemController,
          hintText: 'Tuliskan apa yang kamu pahami dari masalah di atas...',
          maxLines: 4,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildPlanningStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.edit_note_rounded,
          title: 'Membuat Perencanaan',
          subtitle: 'Tentukan rancangan jaringan sebelum praktik.',
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Pilih Topologi Jaringan',
          isDark: isDark,
          child: DropdownButtonFormField<String>(
            value: selectedTopology,
            decoration: _inputDecoration(isDark),
            items: topologies.map((topology) {
              return DropdownMenuItem(
                value: topology,
                child: Text(topology),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedTopology = value;
                });
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildInputCard(
          title: 'Rancangan Jaringan',
          controller: planningController,
          hintText: 'Tuliskan rancangan jaringan yang akan kamu gunakan...',
          maxLines: 5,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildPracticeStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.build_rounded,
          title: 'Melakukan Praktik',
          subtitle: 'Ikuti langkah praktik dan tandai yang sudah selesai.',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Checklist Praktik',
          icon: Icons.checklist_rounded,
          child: Column(
            children: [
              _buildChecklistItem(0, 'Menyiapkan komputer'),
              _buildChecklistItem(1, 'Menyiapkan switch'),
              _buildChecklistItem(2, 'Menyiapkan kabel UTP'),
              _buildChecklistItem(3, 'Menghubungkan komputer ke switch'),
              _buildChecklistItem(4, 'Mengatur IP Address'),
              _buildChecklistItem(5, 'Memastikan koneksi jaringan'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestingStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.network_check_rounded,
          title: 'Menguji Jaringan',
          subtitle: 'Periksa apakah jaringan yang dibuat sudah berjalan.',
        ),
        const SizedBox(height: 16),
        _buildInputCard(
          title: 'Hasil Pengujian & Kendala',
          controller: testingController,
          hintText: 'Tuliskan hasil pengujian, kendala yang ditemukan, dan solusimu...',
          maxLines: 5,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildReflectionStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.auto_awesome_rounded,
          title: 'Refleksi & Unggah Foto Bukti',
          subtitle: 'Evaluasi pengalamanmu dan lampirkan foto dokumentasi project.',
        ),
        const SizedBox(height: 16),
        _buildInputCard(
          title: 'Apa yang kamu pelajari dari project ini?',
          controller: reflectionController,
          hintText: 'Tuliskan pengetahuan atau keterampilan baru yang kamu dapatkan...',
          maxLines: 4,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('UNGGAH FOTO HASIL PROJECT / BUKTI:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
              const SizedBox(height: 10),
              if (_base64File != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.tealTint,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryTeal.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.image_rounded, color: AppTheme.primaryTeal, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _fileName ?? 'foto_project.jpg',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppTheme.accentRed),
                        onPressed: () => setState(() {
                          _pickedFile = null;
                          _base64File = null;
                          _fileName = null;
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: _pickProjectFile,
                  icon: const Icon(Icons.attach_file_rounded, size: 18),
                  label: Text(_base64File == null ? 'Unggah Foto Bukti Project' : 'Ganti Foto Bukti'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryTeal,
                    side: const BorderSide(color: AppTheme.primaryTeal),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.tealTint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: AppTheme.primaryTeal,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.borderCream,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.tealTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: AppTheme.primaryTeal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    int maxLines = 4,
  }) {
    return _buildSectionCard(
      title: title,
      isDark: isDark,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark, fontSize: 13),
        decoration: _inputDecoration(isDark).copyWith(
          hintText: hintText,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(
        color: AppTheme.textMuted,
        fontSize: 13,
      ),
    );
  }

  Widget _buildChecklistItem(int index, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          practiceChecklist[index] = !practiceChecklist[index];
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: practiceChecklist[index],
              activeColor: AppTheme.primaryTeal,
              onChanged: (value) {
                setState(() {
                  practiceChecklist[index] = value ?? false;
                });
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  decoration: practiceChecklist[index] ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final isLastStep = currentStep == steps.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(
          top: BorderSide(
            color: AppTheme.borderCream,
          ),
        ),
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  side: const BorderSide(
                    color: AppTheme.borderCream,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 48),
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      isLastStep ? 'Selesaikan & Kumpulkan' : 'Simpan & Lanjut',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
      return;
    }

    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kumpulkan Project?'),
          content: const Text(
            'Kamu akan mengumpulkan seluruh tahapan project beserta file/foto bukti ke Dasbor Guru.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _submitProjectToFirestore();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Project berhasil dikumpulkan ke Dasbor Guru!'), behavior: SnackBarBehavior.floating),
                  );
                  Navigator.pop(context, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Kumpulkan Ke Guru'),
            ),
          ],
        );
      },
    );
  }
}

class ProjectStep {
  final String title;
  final IconData icon;

  const ProjectStep({
    required this.title,
    required this.icon,
  });
}
