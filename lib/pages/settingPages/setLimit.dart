import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot/components/bottom_bar.dart';

class SetLimit extends StatefulWidget {
  static const String id = "SetLimit";


  const SetLimit({super.key});

  @override
  State<SetLimit> createState() => _SetLimitState();
}

class _SetLimitState extends State<SetLimit> {
  late TextEditingController _controller;
  late double _currentLimit;
  late double curWattLimit = 0;
  late String userId;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      _loadLimit(); // Load limit after user is set
    }
  }

  Future<void> _loadLimit() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('usageLimit');
    databaseReference.once().then((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          _currentLimit = (data as num).toDouble() / 1000;
          _controller.text = '$_currentLimit';
          curWattLimit = _currentLimit * 1000;
        });
      } else {
        setState(() {
          _controller.text = '$_currentLimit';
          curWattLimit = _currentLimit * 1000;
        });
      }
    }).catchError((error) {
      print("Failed to load limit: $error");
      setState(() {
        _controller.text = '$_currentLimit';
        curWattLimit = _currentLimit * 1000;
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _currentLimit++;
      _controller.text = '$_currentLimit';
      curWattLimit = _currentLimit * 1000;
    });
  }

  void _decrementCounter() {
    setState(() {
      _currentLimit--;
      _controller.text = '$_currentLimit';
      curWattLimit = _currentLimit * 1000;
    });
  }

  void _updateCounterFromText(String value) {
    setState(() {
      curWattLimit = _currentLimit * 1000;
    });
  }

  Future<void> _saveLimit() async {
    // Save to Firebase
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('usageLimit');
    databaseReference.set(curWattLimit).then((_) {
      print("Firebase: Limit saved successfully");
    }).catchError((error) {
      print("Firebase: Failed to save limit: $error");
    });

    // Navigate back with new limit
    Navigator.pop(context, _currentLimit);
  }

  @override
  Widget build(BuildContext context) {
    print('current watt: $curWattLimit');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Limit'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 70.0),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              elevation: 5.0,
              child: SizedBox(
                height: 400.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text(
                          'Set Usage Limit:',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.red,
                                size: 34.0,
                              ),
                              onPressed: _decrementCounter,
                            ),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'UNIT',
                                ),
                                textAlign: TextAlign.center,
                                onSubmitted: _updateCounterFromText,
                                onChanged: _updateCounterFromText,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_drop_up,
                                color: Colors.green,
                                size: 34.0,
                              ),
                              onPressed: _incrementCounter,
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _saveLimit,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const bottomBar(currentPageId: SetLimit.id)
        ],
      ),
    );
  }
}
