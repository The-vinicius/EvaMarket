import 'package:evamarket/app/interactor/store_stocks.dart';
import 'package:evamarket/app/ui/states/data_state.dart';
import 'package:evamarket/app/ui/tabs/home_tab.dart';
import 'package:evamarket/app/ui/tabs/profile_tab.dart';
import 'package:evamarket/app/ui/tabs/search_tab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  // final stocks = StoreStocks();
  int index = 0;
  @override
  void initState() {
    super.initState();
    stocks.addListener(listener);
  }

  void listener() {
    setState(() {});
  }

  // Lista de tickers
  final List<String> tickers = [
    'AAPL',
    'BTC-USD',
    'TSLA',
    'GOOG',
    'MSFT',
    'AMZN',
    'picademel',
  ];

  // Ticker selecionado
  String? selectedTicker;
  final now = DateTime.now();
  List<Widget> pages = [const HomeTab(), const SearchTab(), const ProfileTab()];

  @override
  Widget build(BuildContext context) {
    // final stocks = StoreStocks();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EvaMarket",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   DropdownButton<String>(
        //     value: stocks.selectedTicker,
        //     hint: const Text("ticker"),
        //     // icon: const Icon(Icons.arrow_drop_down),
        //     // borderRadius: BorderRadius.circular(20),
        //     // style: const TextStyle(color: Colors.black, fontSize: 16),
        //     // dropdownColor: Colors.white,
        //     icon: const RotatedBox(
        //         quarterTurns: 1,
        //         child: Icon(Icons.chevron_right, color: Colors.deepPurple)),
        //     iconSize: 24,
        //     padding: const EdgeInsets.all(5),
        //     elevation: 16,
        //     style: const TextStyle(color: Colors.deepPurple),
        //     underline: Container(
        //       height: 2,
        //       color: Colors.deepPurple,
        //     ),
        //     // elevation: 16,
        //     onChanged: (String? value) async {
        //       if (value != null) {
        //         await stocks.getStock(value, DateTime(2024));
        //       }
        //     },
        //     items: tickers.map<DropdownMenuItem<String>>((String ticker) {
        //       return DropdownMenuItem<String>(
        //         value: ticker,
        //         child: Text(ticker),
        //       );
        //     }).toList(),
        //   ),
        // ],
      ),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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

class _ChartData {
  final DateTime date;
  final double price;

  _ChartData(this.date, this.price);
}
