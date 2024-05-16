import 'package:flutter/material.dart';

class eBil extends StatelessWidget {
  static const String id = 'eBil';
  const eBil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'E-Bill'
        ),
      ),
      body: Container(),
    );
  }
}
