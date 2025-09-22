import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/ui/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:evamarket/app/interactor/store_price.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
// Definição do canal de notificação (Android)
const AndroidNotificationChannel bitcoinChannel = AndroidNotificationChannel(
  'bitcoin_price_channel',
  'Bitcoin Price Channel',
  description: 'Notificações diárias do preço do Bitcoin',
  importance: Importance.high,
);

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _setupBackgroundTask();
  }

  Future<void> _setupBackgroundTask() async {
    // Request notification permissions
    await _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    // Request notification permission
    final notificationStatus = await Permission.notification.request();
    
    // For iOS, also request background refresh permission
    if (notificationStatus.isDenied) {
      // Show dialog to user explaining why permission is needed
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Notification Permission Required'),
            content: const Text(
              'This app needs notification permission to send you daily Bitcoin price updates at 7 AM.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    }
  }

  Duration _getInitialDelay() {
    final now = DateTime.now();
    final next7am = DateTime(now.year, now.month, now.day, 7);
    final target7am = next7am.isAfter(now) ? next7am : next7am.add(const Duration(days: 1));
    return target7am.difference(now);
  }

  @override
  Widget build(BuildContext context) {
    // future return
    return FutureBuilder(future: init(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return const Center(
          child: HomePage(),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}

Future<void> init() async {
  const androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  const settings = InitializationSettings(android: androidSettings);
  await FlutterLocalNotificationsPlugin().initialize(settings);
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(bitcoinChannel);
}

// Top-level function for workmanager callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await init();
    
    switch (task) {
      case "fetchBitcoinPrice":
        final data = await const YahooFinanceDailyReader()
          .getDailyDTOs('BTC-USD', startDate: DateTime.now());
  final price = data.candlesData.first.close;
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  await notificationPlugin.show(
    0,
    'Bitcoin Price',
    'BTC-USD: ${price.toStringAsFixed(2)}',
    NotificationDetails(
                  android: AndroidNotificationDetails(
                    bitcoinChannel.id,
                    bitcoinChannel.name,
                    channelDescription: 'Notifications for Eva Market app',
                    importance: Importance.max,
                    priority: Priority.high,
                    icon: '@mipmap/ic_launcher',
                  ),
                ),
  );
        break;
    }
    return Future.value(true);
  });
}

// Top-level function for background execution
@pragma('vm:entry-point')
Future<void> fetchAndNotifyBitcoinPrice() async {
  // Initialize timezone for notifications
  tz.initializeTimeZones();

  final data = await const YahooFinanceDailyReader()
          .getDailyDTOs('BTC-USD', startDate: DateTime.now());
  final price = data.candlesData.first.close;
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  await notificationPlugin.show(
    0,
    'Bitcoin Price',
    'BTC-USD: ${price.toStringAsFixed(2)}',
    NotificationDetails(
                  android: AndroidNotificationDetails(
                    bitcoinChannel.id,
                    bitcoinChannel.name,
                    channelDescription: 'Notifications for Eva Market app',
                    importance: Importance.max,
                    priority: Priority.high,
                    icon: '@mipmap/ic_launcher',
                  ),
                ),
  );
}

