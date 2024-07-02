import 'package:flutter/material.dart';
import 'package:iot/pages/settingPages/reminderPage.dart';
import 'package:iot/pages/settingPages/setLimit.dart';
import 'package:iot/pages/settingPages/set_To_Off.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/pages/logIn/initialPage.dart';
import 'package:iot/pages/settingPages/tecSupport.dart';
import 'package:iot/components/bottom_bar.dart';

import '../main.dart';

class SettingPage extends StatefulWidget {
  static const String id = "settingPage";

  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String userName = "User Name";
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'User Name';
      _controller.text = userName;
    });
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: withDraggableFAB(Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 15.0,
                ),
                const CircleAvatar(
                  radius: 55,
                  child: ImageIcon(
                    size: double.maxFinite,
                    AssetImage('images/user icon.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isEditing
                      ? Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(fontSize: 30.0, color: Colors.white),
                          onSubmitted: (value) {
                            setState(() {
                              userName = value;
                              isEditing = false;
                            });
                            _saveUserName(value);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          setState(() {
                            userName = _controller.text;
                            isEditing = false;
                          });
                          _saveUserName(_controller.text);
                        },
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 30.0, color: Colors.white),
                      ),
                      const SizedBox(width: 30.0),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                            _controller.text = userName;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                      ),
                      // elevation: 2,
                      color: Colors.blueGrey[900],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 60.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, SetLimit.id);
                              },
                              child: const NewCard(text: 'Set Limit'),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ReminderPage.id);
                              },
                              child: const NewCard(text: 'Reminder'),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, SetToOff.id);
                              },
                              child: const NewCard(text: 'Set Off'),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, TecSupport.id);
                              },
                              child: const NewCard(text: 'Tec Support'),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, InitialPage.id);
                              },
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
                                ),
                                color: Colors.red[900],
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 60.0, vertical: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.exit_to_app),
                                      SizedBox(width: 20.0),
                                      Text(
                                        'Log Out',
                                        style: TextStyle(
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const bottomBar(currentPageId: SettingPage.id),
                ],
              ),
            ),

          ],
        ),
      )),
    );
  }
}

class NewCard extends StatelessWidget {
  final String text;

  const NewCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(35.0)),
      ),
      color: Colors.red[900],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
