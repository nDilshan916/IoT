import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool isSwitched;

  const CustomSwitch({required this.isSwitched});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 73,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: isSwitched ? Colors.black : Colors.white,
        border: Border.all(
          color: isSwitched ? Colors.transparent : Colors.black,
          width: 3,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: isSwitched ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 35,
              height: 29,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSwitched ? Colors.white : Colors.black,
              ),
            ),
          ),
          Align(
            alignment: isSwitched ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Text(
                isSwitched ? 'ON' : 'OFF',
                style: TextStyle(
                  color: isSwitched ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}