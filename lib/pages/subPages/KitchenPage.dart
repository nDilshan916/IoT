import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';

class KitchenPage extends StatelessWidget {
  static const String id = 'KitchenPage';

  const KitchenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Kitchen'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              'Switches in the Kitchen',
              style: TextStyle(fontSize: 24),
            ),
          ),
          bottomBar(currentPageId: id),
        ],
      ),
    );
  }
}
