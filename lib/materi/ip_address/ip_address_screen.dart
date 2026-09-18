import 'package:flutter/material.dart';

class IpAddressScreen extends StatelessWidget {
  const IpAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Address'),
      ),
      body: const Center(
        child: Text(
          'Materi IP Address',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}