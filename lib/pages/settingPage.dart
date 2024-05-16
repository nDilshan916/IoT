import 'package:flutter/material.dart';
import 'package:iot/components//bottom_bar.dart';

class SettingPage extends StatelessWidget {
  static const String id = "settingPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text('user settings'),
          ),
          bottomBar(currentPageId: id),
        ],
      ),
    );
  }
}
