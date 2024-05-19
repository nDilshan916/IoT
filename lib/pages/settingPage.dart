import 'package:flutter/material.dart';
import 'package:iot/components//bottom_bar.dart';

class SettingPage extends StatelessWidget {
  static const String id = "settingPage";

  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: const Text('user settings'),
          ),
          const bottomBar(currentPageId: id),
        ],
      ),
    );
  }
}
