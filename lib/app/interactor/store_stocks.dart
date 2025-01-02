import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/models/asset_model.dart';
import 'package:evamarket/app/models/chart_data.dart';
import 'package:evamarket/app/repositories/data_repository.dart';
import 'package:flutter/foundation.dart';

class StoreStocks extends ChangeNotifier {
  bool loading = false;
  AssetModel? assetModel;
  bool error = false;
  String? selectedTicker;
  List<ChartData> data = [];
  List<double> rsi = [];

  Future<void> getStock(String stock, DateTime date) async {
    loading = true;
    error = false;
    selectedTicker = stock;
    notifyListeners();
    final repository = injector.get<DataRepository>();
    final result = await repository.getDate(stock, date);
    result.fold((result) {
      assetModel = result;
      rsi = _calculateRSI(assetModel!.prices);
      data = chartDataStock();
    }, (e) {
      error = true;
    });
    loading = false;
    notifyListeners();
  }

  void graph(int days) {
    if (days > chartDataStock().length) {
      days = chartDataStock().length;
    }
    data = chartDataStock().sublist(chartDataStock().length - days);
    notifyListeners();
  }

  List<ChartData> chartDataStock() {
    if (assetModel != null) {
      return List.generate(
          assetModel!.dates.length,
          (index) => ChartData(
              assetModel!.dates[index], assetModel!.prices[index], rsi[index]));
    }
    return [ChartData(DateTime.now(), 0.0, 0.0)];
  }

  double currentPrice() {
    if (assetModel != null) return assetModel!.prices.last;
    return 0.0;
  }

  double minPrice() {
    final price = data.reduce(
        (values, element) => values.price < element.price ? values : element);
    return price.price;
  }

  //function calculate porcentagem
  double porcentagem() {
    final price = data.first;
    return (currentPrice() - price.price) / price.price * 100;
  }

  List<double> _calculateRSI(List<double> closePrices, {int period = 20}) {
    List<double> rsi = List.filled(closePrices.length, 0);
    if (closePrices.length < period) return rsi;

    double avgGain = 0;
    double avgLoss = 0;

    // Calcular os ganhos e perdas iniciais
    for (int i = 1; i < period; i++) {
      double change = closePrices[i] - closePrices[i - 1];
      if (change > 0) {
        avgGain += change;
      } else {
        avgLoss -= change;
      }
    }

    avgGain /= period;
    avgLoss /= period;

    // Calcular o RSI
    for (int i = period; i < closePrices.length; i++) {
      double change = closePrices[i] - closePrices[i - 1];
      avgGain = ((avgGain * (period - 1)) + (change > 0 ? change : 0)) / period;
      avgLoss =
          ((avgLoss * (period - 1)) + (change < 0 ? -change : 0)) / period;

      double rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
      rsi[i] = 100 - (100 / (1 + rs));
    }

    return rsi;
  }

  double minRSI() {
    final rsi = data.reduce(
        (values, element) => values.rsi < element.rsi ? values : element);
    return rsi.rsi;
  }
}
