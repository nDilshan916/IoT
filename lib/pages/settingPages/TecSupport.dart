import 'package:flutter/material.dart';

class TecSupport extends StatelessWidget {
  static const String id = 'TecSupport';

  const TecSupport({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tec Support'),
      ),
      body: Container(
        child: const Center(
          child: Text('Contact us'),
        ),
      ),
    );
  }
}
