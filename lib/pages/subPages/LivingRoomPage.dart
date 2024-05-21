import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';

class LivingRoomPage extends StatelessWidget {
  static const String id = 'LivingRoomPage';

  const LivingRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Living Room'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              'Switches in the Living Room',
              style: TextStyle(fontSize: 24),
            ),
          ),
          bottomBar(currentPageId: id),
        ],
      ),
    );
  }
}
