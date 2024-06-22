import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../settingPage.dart';

class ReminderPage extends StatefulWidget {
  static const String id = "ReminderPage";

  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  double _reminderValue = 0.0;
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadReminder();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  void _loadReminder() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('reminderValue');
    databaseReference.once().then((DatabaseEvent snapshot) { // Change DataSnapshot to DatabaseEvent
      final value = snapshot.snapshot.value; // Use snapshot.snapshot.value to access data
      if (value != null) {
        setState(() {
          _reminderValue = (value as num).toDouble(); // Ensure the value is converted to double
        });
      }
    }).catchError((error) {
      print("Failed to load reminder value: $error");
    });
  }


  void _saveReminder(double value) async {
    // Save to Firebase
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('reminderValue');
    databaseReference.set(value).then((_) {
      print("Firebase: Reminder saved successfully");
    }).catchError((error) {
      print("Firebase: Failed to save reminder: $error");
    });

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('reminderValue', value);
  }

  void _setReminder() {
    _saveReminder(_reminderValue);
    // Here you might want to schedule a notification or perform any other reminder setup
    Navigator.pushNamed(context, SettingPage.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder set at $_reminderValue% usage')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminder'),
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
                  child: const Text('Set Reminder'),
                ),
              ],
            ),
          ),
          const bottomBar(currentPageId: ReminderPage.id)
        ],
      ),
    );
  }
}
