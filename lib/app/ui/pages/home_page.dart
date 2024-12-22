import 'package:evamarket/app/interactor/store_stocks.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final stocks = StoreStocks();
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: stocks,
      builder: (context, w) {
        if (stocks.loading) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: LinearProgressIndicator(),
          );
        } else if (stocks.assetModel == null || stocks.error) {
          return const Center(
            child: Text(
              'Sem Dados',
              key: Key('Sem'),
            ),
          );
        } else {
          final market = stocks.assetModel!;
          final chartData = List.generate(market.dates.length,
              (index) => _ChartData(market.dates[index], market.prices[index]));

          final mim = market.prices
              .reduce((value, element) => value < element ? value : element);
          return Column(
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        final date = DateTime(now.year, now.month, now.day - 7);
                        await stocks.getStock(market.ticker, date);
                      },
                      child: const Text('1W')),
                  TextButton(
                      onPressed: () async {
                        final date = DateTime(now.year, now.month - 1, now.day);

                        await stocks.getStock(market.ticker, date);
                      },
                      child: const Text('1M')),
                  TextButton(
                      onPressed: () async {
                        final date = DateTime(now.year - 1, now.month, now.day);

                        await stocks.getStock(market.ticker, date);
                      },
                      child: const Text('1Y')),
                  const Spacer(),
                  Text("Price: \$${market.prices.last.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 300,
                child: SfCartesianChart(
                  trackballBehavior: TrackballBehavior(enable: true),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching:
                        true, // Permite zoom com pinça (pinch-to-zoom)
                    enablePanning: true, // Permite arrastar
                    zoomMode: ZoomMode.xy, // Habilita zoom nos eixos X e Y
                  ),
                  // title: ChartTitle(
                  //     text: '\$${stocks.currentPrice().toStringAsFixed(2)}',
                  //     alignment: ChartAlignment.far),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: DateTimeAxis(
                    intervalType: DateTimeIntervalType.months,
                    dateFormat: DateFormat.yMd(),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(
                    tickPosition: TickPosition.inside,
                    // title: AxisTitle(text: 'Preço (\$)'),
                    minimum: mim - 10,
                    // interval: 1,
                    labelFormat: '\${value}',
                    numberFormat: NumberFormat.compact(),
                  ),
                  series: [
                    LineSeries<_ChartData, DateTime>(
                        animationDelay: 0.0,
                        animationDuration: 0,
                        name: "price",
                        dataSource: chartData,
                        pointColorMapper: (_ChartData data, _) =>
                            data.price < market.prices[0]
                                ? Colors.red
                                : Colors.green,
                        // markerSeneSeriettings: const MarkerSettings(isVisible: true),
                        xValueMapper: (_ChartData data, _) => data.date,
                        yValueMapper: (_ChartData data, _) => data.price),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class _ChartData {
  final DateTime date;
  final double price;

  _ChartData(this.date, this.price);
}
