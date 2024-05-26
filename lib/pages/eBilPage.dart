import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';

class eBil extends StatelessWidget {
  static const String id = 'eBil';
  const eBil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'E-Bill'
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            const bottomBar(currentPageId: id),
          ],
        ),
      ),
    );
  }
}
