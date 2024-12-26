import 'package:evamarket/app/models/ticker_model.dart';
import 'package:evamarket/app/ui/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ticker = ModalRoute.of(context)!.settings.arguments as TickerModel;
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 3, left: 5),
                child: Text(
                  "${stocks.assetModel?.prices.last.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  ticker.name,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ListenableBuilder(
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
                    final chartData = List.generate(
                        market.dates.length,
                        (index) => _ChartData(
                            market.dates[index], market.prices[index]));

                    final mim = market.prices.reduce(
                        (value, element) => value < element ? value : element);
                    return Column(
                      children: [
                        Row(
                          children: [
                            TextButton(
                                onPressed: () async {
                                  final date = DateTime(
                                      now.year, now.month, now.day - 7);
                                  await stocks.getStock(market.ticker, date);
                                },
                                child: const Text('1W')),
                            TextButton(
                                onPressed: () async {
                                  final date = DateTime(
                                      now.year, now.month - 1, now.day);

                                  await stocks.getStock(market.ticker, date);
                                },
                                child: const Text('1M')),
                            TextButton(
                                onPressed: () async {
                                  final date = DateTime(
                                      now.year - 1, now.month, now.day);

                                  await stocks.getStock(market.ticker, date);
                                },
                                child: const Text('1Y')),
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
                              zoomMode:
                                  ZoomMode.xy, // Habilita zoom nos eixos X e Y
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
                              minimum: mim,
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
                                  xValueMapper: (_ChartData data, _) =>
                                      data.date,
                                  yValueMapper: (_ChartData data, _) =>
                                      data.price),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  final DateTime date;
  final double price;

  _ChartData(this.date, this.price);
}
