import 'package:flutter/material.dart';

class CustomMaterialReaderScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const CustomMaterialReaderScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final title = data['judul'] ?? 'Materi Pembelajaran';
    final category = data['kategori'] ?? 'Umum';
    final guruName = data['guruName'] ?? 'Guru Netropia';
    final content = data['isi'] ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFAD8B73),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFAD8B73).withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFAD8B73).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFAD8B73),
                    child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diterbitkan oleh: $guruName',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kategori: $category',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
