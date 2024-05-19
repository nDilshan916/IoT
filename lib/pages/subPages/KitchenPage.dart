import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';

class KitchenPage extends StatelessWidget {
  static const String id = 'KitchenPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Kitchen'),
      ),
      body: Column(
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
