import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:iot/pages/subPages/KitchenPage.dart';
import 'package:iot/pages/subPages/LivingRoomPage.dart';
import 'package:iot/pages/subPages/Room_1_Page.dart';

class SwitchPage extends StatefulWidget {
  static const String id = 'SwitchPage';

  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {

  //Living Room
  bool isLivingRoomOn = false;
  bool isLrACOn = false;
  bool isLrLight1On = false;

  //room 1
  bool isRoom1On = false;
  bool isR1FanOn = false;
  bool isR1Light1On = false;
  bool isR1Light2On = false;



  @override
  void initState() {
    super.initState();
    _loadSwitchStates();
  }

  void _loadSwitchStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isR1FanOn = prefs.getBool('isR1FanOn') ?? false;
      isR1Light1On = prefs.getBool('isR1Light1On') ?? false;
      isR1Light2On = prefs.getBool('isR1Light2On') ?? false;
      isLrACOn = prefs.getBool('isLrACOn') ?? false;
      isLrLight1On = prefs.getBool('isLrLight1On') ?? false;
      isRoom1On = isR1FanOn || isR1Light1On || isR1Light2On;
      isLivingRoomOn = isLrACOn || isLrLight1On;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Switch Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LivingRoomPage.id).then((_) {
                              _loadSwitchStates(); // Reload switch states when coming back
                            });
                          },
                          child: SwitchCards(
                            switchImage: 'images/living room switch.png',
                            switchName: 'Living Room',
                            isSwitchOn: isLivingRoomOn, // Assuming false for demo
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Room_1_Page.id).then((_) {
                              _loadSwitchStates(); // Reload switch states when coming back
                            });
                          },
                          child: SwitchCards(
                            switchImage: 'images/room switch.png',
                            switchName: 'Room 1',
                            isSwitchOn: isRoom1On,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: const SwitchCards(
                            switchImage: 'images/room switch.png',
                            switchName: 'Room 2',
                            isSwitchOn: false, // Assuming false for demo
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: const SwitchCards(
                            switchImage: 'images/room switch.png',
                            switchName: 'Room 3',
                            isSwitchOn: false, // Assuming false for demo
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: const SwitchCards(
                            switchImage: 'images/room switch.png',
                            switchName: 'Room 4',
                            isSwitchOn: false, // Assuming false for demo
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, KitchenPage.id);
                          },
                          child: const SwitchCards(
                            switchImage: 'images/kitchen button.png',
                            switchName: 'Kitchen',
                            isSwitchOn: false, // Assuming false for demo
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const bottomBar(currentPageId: SwitchPage.id),
          ],
        ),
      ),
    );
  }
}
