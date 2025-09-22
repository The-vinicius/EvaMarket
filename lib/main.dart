import 'dart:io';

import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/ui/screens/graph_page.dart';
import 'package:evamarket/app/ui/screens/home_page.dart';
import 'package:evamarket/app/ui/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  setupInjector();
  await init();
  if (Platform.isAndroid) {
  Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  Workmanager().registerPeriodicTask(
      "bitcoin-price-notification",
      "fetchBitcoinPrice",
      frequency: const Duration(seconds:  10),
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EvaMarket',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (constext) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/graph': (context) => const GraphPage(),
      },
    );
  }
}
