import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/reusable_card.dart';

class LivingRoomPage extends StatefulWidget {
  static const String id = 'LivingRoomPage';

  const LivingRoomPage({super.key});

  @override
  State<LivingRoomPage> createState() => _LivingRoomPageState();
}

class _LivingRoomPageState extends State<LivingRoomPage> {
  late bool isLrACOn = false;
  late bool isLrLight1On = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLrACOn = prefs.getBool('isLrACOn') ?? false;
      isLrLight1On = prefs.getBool('isLrLight1On') ?? false;
    });
  }

  void _saveSwitchState(String key, bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    //update firestore
    await _updateTheFireStore(key, value);

  }

  Future<void> _updateTheFireStore(String key, bool status) async {
    if (key == 'isLrACOn') {
      await _firestore.collection('LivingRoom').doc('ACStatus').set({
        'isLrACOn': status,
      });
    } else if (key == 'isLrLight1On') {
      await _firestore.collection('LivingRoom').doc('Light1Status').set({
        'isLrLight1On': status,
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Living Room'),
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
                        switchImage: 'images/AC_switch.png',
                        switchName: 'AC',
                        isSwitchOn: isLrACOn,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isLrACOn,
                          onChanged: (value) {
                            setState(() {
                              isLrACOn = value;
                              _saveSwitchState('isLrACOn', isLrACOn);
                            });
                          },
                          activeTrackColor: Colors.white70,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      SwitchCards(
                        switchImage: 'images/light_switch.png',
                        switchName: 'Light 1',
                        isSwitchOn: isLrLight1On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isLrLight1On,
                          onChanged: (value) {
                            setState(() {
                              isLrLight1On = value;
                              _saveSwitchState('isLrLight1On', isLrLight1On);
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
          const bottomBar(currentPageId:  LivingRoomPage.id),
        ],
      ),
    );
  }
}
