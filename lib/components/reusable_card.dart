import 'package:flutter/material.dart';

class SwitchCards extends StatelessWidget {
  final String switchImage;
  final String switchName;
  final bool isSwitchOn;

  const SwitchCards({
    super.key,
    required this.switchImage,
    required this.switchName,
    required this.isSwitchOn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 9.0,
      margin: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
      color: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  switchImage,
                  width: 100,
                  height: 125,
                ),
                const SizedBox(height: 1),
                Text(
                  switchName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSwitchOn ? Colors.yellow[800] : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
