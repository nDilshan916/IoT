import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetLimit extends StatefulWidget {
  static const String id = "SetLimit";
  final double currentLimit;

  const SetLimit({super.key, required this.currentLimit});

  @override
  State<SetLimit> createState() => _SetLimitState();
}

class _SetLimitState extends State<SetLimit> {
  late TextEditingController _controller;
  late double _currentLimit;
  late double curWattLimit = 0;

  @override
  void initState() {
    super.initState();
    _loadLimit();
  }

  Future<void> _loadLimit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLimit = prefs.getDouble('usageLimit') ?? widget.currentLimit;
      _controller = TextEditingController(text: '$_currentLimit');
      curWattLimit = _currentLimit * 1000;
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
      _currentLimit = double.tryParse(value) ?? widget.currentLimit;
    });
  }

  Future<void> _saveLimit() async {
    // Save to Firebase
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('usageLimit');
    databaseReference.set(_currentLimit).then((_) {
      print("Firebase: Limit saved successfully");
    }).catchError((error) {
      print("Firebase: Failed to save limit: $error");
    });

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('usageLimit', _currentLimit);

    // Navigate back with new limit
    Navigator.pop(context, _currentLimit);
  }

  @override
  Widget build(BuildContext context) {
    print('current watt: $curWattLimit');
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Limit'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 70.0),
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
                        Text(
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
                                style: TextStyle(fontSize: 20.0),
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
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomBar(currentPageId: SetLimit.id)
        ],
      ),
    );
  }
}
