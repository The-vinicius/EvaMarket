import 'package:evamarket/app/ui/tabs/home_tab.dart';
import 'package:evamarket/app/ui/tabs/search_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  // final stocks = StoreStocks();
  int index = 0;
  List<Widget> pages = [const HomeTab(), const SearchTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EvaMarket",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            key: const Key('notification'),
            icon: const Icon(Icons.notifications),
            onPressed: () async {
              await FlutterLocalNotificationsPlugin().show(
                0,
                'EvaMarket',
                'You have new notifications {100.000}',
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'eva_market_channel',
                    'Eva Market Notifications',
                    channelDescription: 'Notifications for Eva Market app',
                    importance: Importance.max,
                    priority: Priority.high,
                    icon: '@mipmap/ic_launcher',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            key: Key('home'),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            key: Key('search'),
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}
