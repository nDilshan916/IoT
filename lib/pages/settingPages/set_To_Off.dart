import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SetToOff extends StatefulWidget {
  static const String id = 'SetToOff';
  const SetToOff({Key? key}) : super(key: key);

  @override
  _SetToOffState createState() => _SetToOffState();
}

class _SetToOffState extends State<SetToOff> {
  late DatabaseReference databaseReference;
  late DatabaseReference usageReference;
  Map<String, Map<String, bool>> areas = {};
  Map<String, Map<String, bool>> highPriorityComponents = {};
  int usageLimit = 3000;
  int currentUsage = 0;

  @override
  void initState() {
    super.initState();
    databaseReference = FirebaseDatabase.instance.ref();
    usageReference = FirebaseDatabase.instance.ref().child('hourlyUsage'); // Adjust this path based on your structure
    fetchAreas();
    monitorUsage();
  }

  void fetchAreas() {
    databaseReference.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
        Map<String, Map<String, bool>> areasData = {};
        data.forEach((areaKey, areaValue) {
          if (['currentUsage', 'data', 'hourlyUsage', 'reminderValue', 'usageLimit'].contains(areaKey)) {
            return; // Skip these keys
          }
          if (areaValue is Map) {
            Map<String, bool> switches = {};
            areaValue.forEach((switchKey, switchValue) {
              if (switchValue is Map) {
                switchValue.forEach((statusKey, statusValue) {
                  if (statusValue is bool) {
                    switches[switchKey.toString()] = statusValue;
                  }
                });
              }
            });
            areasData[areaKey] = switches;
          }
        });
        setState(() {
          areas = areasData;
        });
      } else {
        print('No data available.');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  void saveSelectedComponents() async {
    await databaseReference.child('highPriorityComponents').set(highPriorityComponents);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully!')),
    );
    Navigator.pop(context, );
  }

  void monitorUsage() {
    usageReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is int) {
        setState(() {
          currentUsage = snapshot.value as int;
        });
        if (currentUsage >= usageLimit) {
          turnOffLowPrioritySwitches();
        }
      }
    });
  }

  void turnOffLowPrioritySwitches() {
    areas.forEach((area, switches) {
      switches.forEach((switchKey, switchValue) {
        if (!(highPriorityComponents[area]?[switchKey] ?? false)) {
          databaseReference.child(area).child(switchKey).update({'isOn': false});
        }
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usage limit reached. Low priority switches turned off.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set High Priority Switches'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Select high-priority components that should remain on when usage limit is reached:'),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: areas.keys.map((area) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        area,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...areas[area]!.keys.map((switchKey) {
                        return CheckboxListTile(
                          title: Text(switchKey),
                          value: highPriorityComponents[area]?[switchKey] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              highPriorityComponents[area] ??= {};
                              highPriorityComponents[area]![switchKey] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: saveSelectedComponents,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
