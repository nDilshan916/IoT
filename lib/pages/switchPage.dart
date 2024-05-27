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
  late bool isRoom1On = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchStates();
  }

  void _loadSwitchStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isRoom1On = prefs.getBool('isFanOn') ?? false;
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
                            Navigator.pushNamed(context, LivingRoomPage.id);
                          },
                          child: const SwitchCards(
                            switchImage: 'images/living room switch.png',
                            switchName: 'Living Room',
                            isSwitchOn: false, // Assuming false for demo
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
