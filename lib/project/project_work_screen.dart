import 'package:flutter/material.dart';

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
      title: 'Membuat Refleksi',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF263238),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengerjaan Project',
          style: TextStyle(
            color: Color(0xFF263238),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildProgressHeader(progress),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: _buildCurrentStep(),
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(double progress) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.projectTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF263238),
                  ),
                ),
              ),
              Text(
                '${currentStep + 1}/${steps.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
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
              backgroundColor: const Color(0xFFE5EAF0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1565C0),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tahap ${currentStep + 1}: ${steps[currentStep].title}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF607080),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildProblemStep();
      case 1:
        return _buildPlanningStep();
      case 2:
        return _buildPracticeStep();
      case 3:
        return _buildTestingStep();
      case 4:
        return _buildReflectionStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildProblemStep() {
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
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF54616D),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Pertanyaan Pemantik',
          icon: Icons.help_outline_rounded,
          child: const Text(
            'Apa saja perangkat dan kebutuhan yang diperlukan '
                'untuk membangun LAN sederhana?',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF54616D),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildInputCard(
          title: 'Tuliskan pemahamanmu',
          controller: problemController,
          hintText: 'Tuliskan apa yang kamu pahami dari masalah di atas...',
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildPlanningStep() {
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
          child: DropdownButtonFormField<String>(
            value: selectedTopology,
            decoration: _inputDecoration(),
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
        _buildInfoCard(
          title: 'Alat dan Bahan',
          icon: Icons.inventory_2_outlined,
          child: const Column(
            children: [
              _MaterialRow(
                icon: Icons.computer_rounded,
                text: 'Komputer / PC',
              ),
              _MaterialRow(
                icon: Icons.hub_rounded,
                text: 'Switch',
              ),
              _MaterialRow(
                icon: Icons.cable_rounded,
                text: 'Kabel UTP',
              ),
              _MaterialRow(
                icon: Icons.settings_ethernet_rounded,
                text: 'Konektor RJ45',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInputCard(
          title: 'Rancangan Jaringan',
          controller: planningController,
          hintText:
          'Tuliskan rancangan jaringan yang akan kamu gunakan...',
          maxLines: 6,
        ),
      ],
    );
  }

  Widget _buildPracticeStep() {
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
              _buildChecklistItem(
                0,
                'Menyiapkan komputer',
              ),
              _buildChecklistItem(
                1,
                'Menyiapkan switch',
              ),
              _buildChecklistItem(
                2,
                'Menyiapkan kabel UTP',
              ),
              _buildChecklistItem(
                3,
                'Menghubungkan komputer ke switch',
              ),
              _buildChecklistItem(
                4,
                'Mengatur IP Address',
              ),
              _buildChecklistItem(
                5,
                'Memastikan koneksi jaringan',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Catatan Praktik',
          icon: Icons.notes_rounded,
          child: const Text(
            'Lakukan praktik sesuai prosedur keselamatan kerja. '
                'Pastikan setiap perangkat terhubung dengan benar '
                'sebelum melakukan pengujian.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF54616D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.network_check_rounded,
          title: 'Menguji Jaringan',
          subtitle: 'Periksa apakah jaringan yang dibuat sudah berjalan.',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Pengujian',
          icon: Icons.rule_rounded,
          child: const Column(
            children: [
              _TestItem(
                title: 'PC 1 → PC 2',
                description: 'Periksa koneksi menggunakan ping.',
              ),
              _TestItem(
                title: 'PC 2 → PC 3',
                description: 'Pastikan perangkat dapat berkomunikasi.',
              ),
              _TestItem(
                title: 'PC → Gateway',
                description: 'Pastikan konfigurasi IP sudah benar.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInputCard(
          title: 'Hasil Pengujian',
          controller: testingController,
          hintText:
          'Tuliskan hasil pengujian, kendala yang ditemukan, '
              'dan bagaimana kamu mengatasinya...',
          maxLines: 6,
        ),
      ],
    );
  }

  Widget _buildReflectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.auto_awesome_rounded,
          title: 'Membuat Refleksi',
          subtitle: 'Evaluasi pengalamanmu setelah menyelesaikan project.',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Refleksi',
          icon: Icons.psychology_outlined,
          child: const Text(
            'Jawab dengan jujur berdasarkan pengalamanmu selama '
                'mengerjakan project.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF54616D),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildInputCard(
          title: 'Apa yang kamu pelajari?',
          controller: reflectionController,
          hintText: 'Tuliskan pengetahuan atau keterampilan baru...',
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Pertanyaan Refleksi',
          icon: Icons.question_answer_outlined,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReflectionQuestion(
                number: '1',
                text: 'Bagian mana yang paling mudah kamu kerjakan?',
              ),
              _ReflectionQuestion(
                number: '2',
                text: 'Bagian mana yang paling sulit?',
              ),
              _ReflectionQuestion(
                number: '3',
                text: 'Bagaimana kamu mengatasi kesulitan tersebut?',
              ),
              _ReflectionQuestion(
                number: '4',
                text: 'Apa yang akan kamu lakukan lebih baik pada project berikutnya?',
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
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: Color(0xFF1565C0),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Color(0xFF607080),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6EAF0),
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
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: const Color(0xFF1565C0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF263238),
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
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6EAF0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF263238),
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
    int maxLines = 4,
  }) {
    return _buildSectionCard(
      title: title,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        decoration: _inputDecoration().copyWith(
          hintText: hintText,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE0E5EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE0E5EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF1565C0),
          width: 1.5,
        ),
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF9AA5B1),
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: practiceChecklist[index],
              activeColor: const Color(0xFF1565C0),
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
                  fontSize: 14,
                  color: practiceChecklist[index]
                      ? const Color(0xFF7A8794)
                      : const Color(0xFF37474F),
                  decoration: practiceChecklist[index]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
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
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
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
                  minimumSize: const Size(0, 50),
                  side: const BorderSide(
                    color: Color(0xFFD5DCE5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    color: Color(0xFF455A64),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 50),
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isLastStep ? 'Selesaikan Project' : 'Simpan & Lanjut',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
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
          title: const Text('Project Selesai'),
          content: const Text(
            'Kamu telah menyelesaikan seluruh tahapan project. '
            'Jangan lupa periksa kembali hasil pekerjaan dan refleksimu.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Selesai'),
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

class _MaterialRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MaterialRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF1565C0),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF54616D),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestItem extends StatelessWidget {
  final String title;
  final String description;

  const _TestItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF1565C0),
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF37474F),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF78909C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReflectionQuestion extends StatelessWidget {
  final String number;
  final String text;

  const _ReflectionQuestion({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1565C0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF54616D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}