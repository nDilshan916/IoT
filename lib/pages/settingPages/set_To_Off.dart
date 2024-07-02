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
    fetchHighPriorityComponents(); // Fetch high priority components during initialization
    monitorUsage();
  }

  void fetchAreas() {
    databaseReference.child('Components').once().then((DatabaseEvent event) {
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

  void fetchHighPriorityComponents() {
    databaseReference.child('highPriorityComponents').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
        Map<String, Map<String, bool>> highPriorityData = {};
        data.forEach((areaKey, areaValue) {
          if (areaValue is Map) {
            Map<String, bool> switches = {};
            areaValue.forEach((switchKey, switchValue) {
              if (switchValue is bool) {
                switches[switchKey.toString()] = switchValue;
              }
            });
            highPriorityData[areaKey] = switches;
          }
        });
        setState(() {
          highPriorityComponents = highPriorityData;
        });
      } else {
        print('No high priority components data available.');
      }
    }).catchError((error) {
      print('Error fetching high priority components data: $error');
    });
  }

  void saveSelectedComponents() async {
    // Update unchecked checkboxes to false in highPriorityComponents
    areas.forEach((area, switches) {
      switches.forEach((switchKey, switchValue) {
        highPriorityComponents[area] ??= {};
        if (highPriorityComponents[area]![switchKey] == null) {
          highPriorityComponents[area]![switchKey] = false;
        }
      });
    });

    // Save highPriorityComponents back to Firebase
    await databaseReference.child('highPriorityComponents').set(highPriorityComponents);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully!')),
    );

    // Pop the screen
    Navigator.pop(context);
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Select high-priority components that should remain on when usage limit is reached:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80)
                ),
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                  child: ListView(
                    children: areas.keys.map((area) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            area,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                          ...areas[area]!.keys.map((switchKey) {
                            return CheckboxListTile(
                              title: Text(switchKey, style: TextStyle(color: Colors.white54, fontSize: 15, ),),
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
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: saveSelectedComponents,
                child: const Text('Save Settings', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blueGrey[900])
                ),
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
