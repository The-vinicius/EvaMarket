import 'package:evamarket/app/ui/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // future return
    return FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          } else if (snapshot.hasData) {
            return const HomePage();
          }
          return const HomePage();
        });
  }
}

Future<void> init() async {
  const androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  const settings = InitializationSettings(android: androidSettings);
  await FlutterLocalNotificationsPlugin().initialize(settings);
}

