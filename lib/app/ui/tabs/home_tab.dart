import 'package:evamarket/app/interactor/store_stocks.dart';
import 'package:evamarket/app/ui/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomePageState();
}

class _HomePageState extends State<HomeTab> {
  // final stocks = StoreStocks();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('algo'),
    );
  }
}

class _ChartData {
  final DateTime date;
  final double price;

  _ChartData(this.date, this.price);
}
