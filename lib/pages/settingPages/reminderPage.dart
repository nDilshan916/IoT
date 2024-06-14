import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderPage extends StatefulWidget {
  static const String id = "ReminderPage";

  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  double _reminderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReminder();
  }

  void _loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reminderValue = prefs.getDouble('reminderValue') ?? 0.0;
    });
  }

  void _saveReminder(double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('reminderValue', value);
  }

  void _setReminder() {
    _saveReminder(_reminderValue);
    // Here you might want to schedule a notification or perform any other reminder setup
    Navigator.pushNamed(context, HomePage.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder set at $_reminderValue% usage')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Reminder'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 200.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: _reminderValue,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: _reminderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _reminderValue = value;
                    });
                  },
                ),
                Text('Set reminder at ${_reminderValue.toStringAsFixed(0)}% usage'),
                ElevatedButton(
                  onPressed: _setReminder,
                  child: Text('Set Reminder'),
                ),
              ],
            ),
          ),
          bottomBar(currentPageId: ReminderPage.id)
        ],
      ),
    );
  }
}
