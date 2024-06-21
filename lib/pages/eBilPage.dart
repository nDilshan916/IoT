import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class eBil extends StatefulWidget {
  static const String id = 'eBil';
  const eBil({super.key});

  @override
  _eBilState createState() => _eBilState();
}

class _eBilState extends State<eBil> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _billingStartController = TextEditingController();
  final TextEditingController _billingEndController = TextEditingController();
  final TextEditingController _fixedChargeController = TextEditingController();
  final TextEditingController _unitRateXController = TextEditingController();
  final TextEditingController _unitRateYController = TextEditingController();
  final TextEditingController _unitRateZController = TextEditingController();
  final TextEditingController _unitRateSController = TextEditingController();
  final TextEditingController _totalConsumedController = TextEditingController();

  String _result = '';

  @override
  void initState() {
    super.initState();
    _loadUserInputs();
    _billingStartController.addListener(_fetchAndSetTotalConsumed);
    _billingEndController.addListener(_fetchAndSetTotalConsumed);
  }

  @override
  void dispose() {
    _billingStartController.removeListener(_fetchAndSetTotalConsumed);
    _billingEndController.removeListener(_fetchAndSetTotalConsumed);
    _billingStartController.dispose();
    _billingEndController.dispose();
    _fixedChargeController.dispose();
    _unitRateXController.dispose();
    _unitRateYController.dispose();
    _unitRateZController.dispose();
    _unitRateSController.dispose();
    _totalConsumedController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInputs() async {
    final prefs = await SharedPreferences.getInstance();
    _fixedChargeController.text = (prefs.getDouble('fixedCharge') ?? 0.0).toString();
    _unitRateXController.text = (prefs.getDouble('unitRateX') ?? 0.0).toString();
    _unitRateYController.text = (prefs.getDouble('unitRateY') ?? 0.0).toString();
    _unitRateZController.text = (prefs.getDouble('unitRateZ') ?? 0.0).toString();
    _unitRateSController.text = (prefs.getDouble('unitRateS') ?? 0.0).toString();
  }

  Future<void> _saveUserInputs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fixedCharge', double.tryParse(_fixedChargeController.text) ?? 0.0);
    await prefs.setDouble('unitRateX', double.tryParse(_unitRateXController.text) ?? 0.0);
    await prefs.setDouble('unitRateY', double.tryParse(_unitRateYController.text) ?? 0.0);
    await prefs.setDouble('unitRateZ', double.tryParse(_unitRateZController.text) ?? 0.0);
    await prefs.setDouble('unitRateS', double.tryParse(_unitRateSController.text) ?? 0.0);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User inputs saved successfully')));
  }

  Future<void> _fetchAndSetTotalConsumed() async {
    final startDate = _billingStartController.text;
    final endDate = _billingEndController.text;

    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      try {
        final totalConsumedWh = await fetchHourlyUsageData(startDate, endDate);
        final totalConsumedKWh = totalConsumedWh / 1000.0;
        setState(() {
          _totalConsumedController.text = totalConsumedKWh.toStringAsFixed(2);
        });
      } catch (e) {
        // Handle the error
        print("Error fetching data: $e");
      }
    }
  }

  Future<double> fetchHourlyUsageData(String startDate, String endDate) async {
    final databaseRef = FirebaseDatabase.instance.ref().child('hourlyUsage');
    DatabaseEvent event = await databaseRef.once();
    final startDateTime = DateTime.parse(startDate);
    final endDateTime = DateTime.parse(endDate);
    double totalConsumedWh = 0.0;

    if(event.snapshot.exists) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final timestamp = DateTime.parse(key);
        if (timestamp.isAfter(startDateTime) && timestamp.isBefore(endDateTime)) {
          totalConsumedWh += value.toDouble();
        }

      });
      print("total counsume Wh: $totalConsumedWh");
    }

    return totalConsumedWh;

  }


  void _calculateTotalAmount() {
    if (_formKey.currentState?.validate() ?? false) {
      final double fixedCharge = double.tryParse(_fixedChargeController.text) ?? 0.0;
      final double rateX = double.tryParse(_unitRateXController.text) ?? 0.0;
      final double rateY = double.tryParse(_unitRateYController.text) ?? 0.0;
      final double rateZ = double.tryParse(_unitRateZController.text) ?? 0.0;
      final double rateS = double.tryParse(_unitRateSController.text) ?? 0.0;
      final double totalConsumed = double.tryParse(_totalConsumedController.text) ?? 0.0;
      print(totalConsumed);

      double totalAmount = fixedCharge;
      if (totalConsumed > 0) {
        totalAmount += (totalConsumed > 31 ? 31 : totalConsumed) * rateX;
      }
      if (totalConsumed > 31) {
        totalAmount += (totalConsumed > 62 ? 31 : totalConsumed - 31) * rateY;
      }
      if (totalConsumed > 62) {
        totalAmount += (totalConsumed > 93 ? 31 : totalConsumed - 62) * rateZ;
      }
      if (totalConsumed > 93) {
        totalAmount += (totalConsumed - 93) * rateS;
      }

      setState(() {
        _saveUserInputs();
        _result = 'Total amount: Rs.${totalAmount.toStringAsFixed(2)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('E-Bill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _billingStartController,
                decoration: const InputDecoration(
                  labelText: 'Billing Start Date (YYYY/MM/DD)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the billing start date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _billingEndController,
                decoration: const InputDecoration(
                  labelText: 'Billing End Date (YYYY/MM/DD)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the billing end date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fixedChargeController,
                decoration: const InputDecoration(
                  labelText: 'Fixed Charge (Rs.)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the fixed charge';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitRateXController,
                decoration: const InputDecoration(
                  labelText: 'Unit Rate (1-31)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the unit rate for 1-31';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitRateYController,
                decoration: const InputDecoration(
                  labelText: 'Unit Rate (32-62)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the unit rate for 32-62';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitRateZController,
                decoration: const InputDecoration(
                  labelText: 'Unit Rate (63-93)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the unit rate for 63-93';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitRateSController,
                decoration: const InputDecoration(
                  labelText: 'Unit Rate (93+)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the unit rate for 93+';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalConsumedController,
                decoration: const InputDecoration(
                  labelText: 'Total Consumed Units (kWh)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the total consumed units';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateTotalAmount,
                child: const Text('Calculate E-Bill'),
              ),
              const SizedBox(height: 20),
              Text(
                _result,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
