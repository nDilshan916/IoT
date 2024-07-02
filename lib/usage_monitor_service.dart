import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'notification_service.dart';

class UsageMonitorService {
  final DatabaseReference hourlyUsageRef = FirebaseDatabase.instance.ref('hourlyUsage');
  final DatabaseReference usageLimitRef = FirebaseDatabase.instance.ref('usageLimit');
  final DatabaseReference reminderValueRef = FirebaseDatabase.instance.ref('reminderValue');

  UsageMonitorService() {
    _monitorUsage();
  }

  void _monitorUsage() {
    hourlyUsageRef.onValue.listen((event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        DateTime now = DateTime.now();
        String currentDay = DateFormat('yyyy-MM-dd').format(now);

        double dailyTotal = 0.0;
        data.forEach((key, value) {
          if (key.toString().startsWith(currentDay)) {
            dailyTotal += _toDouble(value);
          }
        });

        DataSnapshot limitSnapshot = await usageLimitRef.get();
        if (limitSnapshot.exists) {
          double usageLimit = _toDouble(limitSnapshot.value);
          DataSnapshot reminderSnapshot = await reminderValueRef.get();
          if (reminderSnapshot.exists) {
            double reminderValue = _toDouble(reminderSnapshot.value);
            if (dailyTotal >= usageLimit) {
              NotificationService().showNotification(
                0,
                'Usage Limit Reached',
                'You have reached your daily usage limit of ${usageLimit.toStringAsFixed(0)} units.',
              );
            } else if (reminderValue > 0 && dailyTotal >= (reminderValue / 100) * usageLimit) {
              NotificationService().showNotification(
                0,
                'Usage Reminder',
                'You have reached ${reminderValue.toStringAsFixed(0)}% of your daily usage limit.',
              );
            }
          } else {
            print('No reminder value data available.');
          }
        } else {
          print('No usage limit data available.');
        }
      } else {
        print('No hourly usage data available.');
      }
    });
  }

  double _toDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      throw ArgumentError('Unexpected value type: ${value.runtimeType}');
    }
  }
}



Future<void> checkReminderInBackground() async {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref('hourlyUsage');
  final DatabaseEvent event = await databaseReference.once();

  if (event.snapshot.exists) {
    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
    DateTime now = DateTime.now();
    String currentDay = DateFormat('yyyy-MM-dd').format(now);

    double dailyTotal = 0.0;
    data.forEach((key, value) {
      if (key.toString().startsWith(currentDay)) {
        dailyTotal += (value as double);
      }
    });

    final DatabaseReference reminderRef = FirebaseDatabase.instance.ref('reminderValue');
    final DataSnapshot reminderSnapshot = await reminderRef.get();

    if (reminderSnapshot.exists) {
      double reminderValue = reminderSnapshot.value as double;
      final DatabaseReference limitRef = FirebaseDatabase.instance.ref('usageLimit');
      final DataSnapshot limitSnapshot = await limitRef.get();

      if (limitSnapshot.exists) {
        double usageLimit = limitSnapshot.value as double;
        if (dailyTotal >= usageLimit) {
          NotificationService().showNotification(
            0,
            'Usage Limit Reached',
            'You have reached your daily usage limit of ${usageLimit.toStringAsFixed(2)} kWh.',
          );
        }

        if (reminderValue > 0 && dailyTotal >= (reminderValue / 100) * usageLimit) {
          NotificationService().showNotification(
            0,
            'Usage Reminder',
            'You have reached ${reminderValue.toStringAsFixed(0)}% of your daily usage limit.',
          );
        }
      }
    } else {
      print('No reminder value data available.');
    }
  } else {
    print('No hourly usage data available.');
  }
}
