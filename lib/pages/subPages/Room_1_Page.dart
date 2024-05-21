import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';

class Room_1_Page extends StatefulWidget {
  static const String id = 'Room1Page';

  const Room_1_Page({super.key});

  @override
  State<Room_1_Page> createState() => _Room_1_PageState();
}

class _Room_1_PageState extends State<Room_1_Page> {
  late bool isFanOn = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isFanOn = _prefs.getBool('isFanOn') ?? false;
    });
  }

  void _saveSwitchState(bool value) async {
    await _prefs.setBool('isFanOn', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Room 1'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SwitchCards(
                        switchImage: 'images/fan_switch.png',
                        switchName: 'Fan',
                        isSwitchOn: isFanOn,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isFanOn,
                          onChanged: (value) {
                            setState(() {
                              isFanOn = value;
                              _saveSwitchState(isFanOn);
                            });
                          },
                          activeTrackColor: Colors.white70,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const bottomBar(currentPageId: Room_1_Page.id),
        ],
      ),
    );
  }
}
