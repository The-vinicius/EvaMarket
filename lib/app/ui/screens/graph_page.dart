import 'package:evamarket/app/models/chart_data.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListenableBuilder(
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
                final chartData = stocks.data;
                final mim = stocks.minPrice();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 3, left: 5),
                      child: Row(
                        children: [
                          Text(
                            "${stocks.assetModel?.prices.last.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text("(${stocks.porcentagem().toStringAsFixed(2)}%)"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        ticker.name,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () async {
                              stocks.graph(7);
                            },
                            child: const Text('1W')),
                        TextButton(
                            onPressed: () async {
                              stocks.graph(30);
                            },
                            child: const Text('1M')),
                        TextButton(
                            onPressed: () async {
                              stocks.graph(180);
                            },
                            child: const Text('6M')),
                        TextButton(
                            onPressed: () async {
                              stocks.graph(365);
                            },
                            child: const Text('1Y')),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: SfCartesianChart(
                        trackballBehavior: TrackballBehavior(enable: true),
                        // zoomPanBehavior: ZoomPanBehavior(
                        //   enablePinching:
                        //       true, // Permite zoom com pinça (pinch-to-zoom)
                        //   enablePanning: true, // Permite arrastar
                        //   zoomMode:
                        //       ZoomMode.xy, // Habilita zoom nos eixos X e Y
                        // ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        primaryXAxis: DateTimeAxis(
                          intervalType: DateTimeIntervalType.months,
                          dateFormat: DateFormat.yMd(),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                        ),
                        primaryYAxis: NumericAxis(
                          tickPosition: TickPosition.inside,
                          // title: AxisTitle(text: 'Preço (\$)'),
                          minimum: mim - 1000,
                          isVisible: true,
                          opposedPosition: true,
                          // interval: 1,
                          labelFormat: '{value}',
                          numberFormat: NumberFormat.compact(),
                        ),
                        series: [
                          LineSeries<ChartData, DateTime>(
                              animationDelay: 0.0,
                              animationDuration: 0,
                              name: "price",
                              dataSource: chartData,
                              pointColorMapper: (ChartData data, _) =>
                                  data.price < chartData.first.price
                                      ? Colors.red
                                      : Colors.green,
                              // markerSeneSeriettings: const MarkerSettings(isVisible: true),
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.price),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: SfCartesianChart(
                        trackballBehavior: TrackballBehavior(enable: true),
                        // zoomPanBehavior: ZoomPanBehavior(
                        //   enablePinching:
                        //       true, // Permite zoom com pinça (pinch-to-zoom)
                        //   enablePanning: true, // Permite arrastar
                        //   zoomMode:
                        //       ZoomMode.xy, // Habilita zoom nos eixos X e Y
                        // ),
                        title: const ChartTitle(
                            text: 'RSI', alignment: ChartAlignment.near),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        primaryXAxis: DateTimeAxis(
                          intervalType: DateTimeIntervalType.months,
                          dateFormat: DateFormat.yMd(),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: stocks.minRSI() - 10,
                          tickPosition: TickPosition.inside,
                          numberFormat: NumberFormat.compact(),
                          isVisible: true,
                          opposedPosition: true,
                        ),
                        series: [
                          LineSeries<ChartData, DateTime>(
                              animationDelay: 0.0,
                              animationDuration: 0,
                              name: "RSI (Índice de Força Relativa)",
                              dataSource: chartData,

                              // markerSeneSeriettings: const MarkerSettings(isVisible: true),
                              xValueMapper: (ChartData data, _) => data.date,
                              yValueMapper: (ChartData data, _) => data.rsi),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
