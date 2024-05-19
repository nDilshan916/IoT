import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Room_1_Page extends StatefulWidget {
  static const String id = 'Room1Page';

  @override
  State<Room_1_Page> createState() => _Room_1_PageState();
}

class _Room_1_PageState extends State<Room_1_Page> {
  late bool isFanOn = false;

  // Initialize SharedPreferences instance
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadSwitchState(); // Load switch state when the widget is initialized
  }

  // Load switch state from SharedPreferences
  void _loadSwitchState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isFanOn = _prefs.getBool('isFanOn') ?? false;
    });
  }

  // Save switch state to SharedPreferences
  void _saveSwitchState(bool value) async {
    _prefs.setBool('isFanOn', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Room 1'),
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
                      switchButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomBar(currentPageId: Room_1_Page.id,),
        ],
      ),
    );
  }

  // Switch button widget
  Positioned switchButton() {
    return Positioned(
      bottom: 1,
      right: 20,
      child: IconButton(
        onPressed: () {
          setState(() {
            isFanOn = !isFanOn; // Toggle switch state
            _saveSwitchState(isFanOn); // Save switch state
          });
        },
        icon: Switch(
          value: isFanOn,
          onChanged: (value) {
            setState(() {
              isFanOn = value;
              _saveSwitchState(isFanOn); // Save switch state
            });
          },
          activeTrackColor: Colors.white70,
          activeColor: Colors.green,
        ),
      ),
    );
  }
}
