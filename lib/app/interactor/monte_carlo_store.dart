import 'dart:math';

import 'package:flutter/material.dart';

class MonteCarloStore extends ChangeNotifier {
  final int simulations = 30; // Número de caminhos simulados
  final int periods = 30; // Dias úteis no ano
  final double meanReturn = 0.0014; // Retorno médio diário (0.05%)
  final double stdDev = 0.034; // Desvio padrão dos retornos diários (2%)

  List<List<ChartPrice>> simulationPaths = [];
  List<double> finalPrices = [];
  double p5 = 0.0;
  double p95 = 0.0;
  double var1 = 0.0;
  double var5 = 0.0;

  void runMonteCarloSimulation(double initialPrice) {
    final random = Random();
    final paths = <List<ChartPrice>>[];
    final prices = <double>[];

    for (int i = 0; i < simulations; i++) {
      final path = <ChartPrice>[ChartPrice(0, initialPrice)];
      for (int j = 1; j <= periods; j++) {
        final randomReturn = meanReturn + stdDev * random.nextGaussian();
        final nextValue = path.last.price * (1 + randomReturn);
        path.add(ChartPrice(j, nextValue));
      }
      paths.add(path);
      prices.add(path.last.price); // Coleta o preço final do período
    }

    // Ordena os preços finais e calcula os percentis e VaR
    prices.sort();

    finalPrices = prices;
    p5 = getPercentile(finalPrices, 0.05);
    p95 = getPercentile(finalPrices, 0.95);
    var1 = (1 - initialPrice / getPercentile(finalPrices, 0.01)) * 100;
    var5 = (1 - initialPrice / getPercentile(finalPrices, 0.10)) * 100;
    simulationPaths = paths;
    notifyListeners();
  }

  double getPercentile(List<double> data, double percentile) {
    final index = (percentile * data.length).floor();
    return data[index];
  }
}

class ChartPrice {
  final int day;
  final double price;

  ChartPrice(this.day, this.price);
}

extension RandomGaussian on Random {
  /// Gera um número aleatório com distribuição normal (gaussiana).
  double nextGaussian() {
    double u = 0, v = 0, s = 0;
    while (s >= 1 || s == 0) {
      u = nextDouble() * 2 - 1;
      v = nextDouble() * 2 - 1;
      s = u * u + v * v;
    }
    final multiplier = sqrt(-2.0 * log(s) / s);
    return u * multiplier;
  }
}
