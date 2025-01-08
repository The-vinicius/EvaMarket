import 'dart:io';

import 'package:evamarket/app/core/helper/percent_message.dart';
import 'package:evamarket/app/interactor/monte_carlo_store.dart';
import 'package:evamarket/app/interactor/store_price.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomePageState();
}

class _HomePageState extends State<HomeTab> {
  final storePrices = StorePrice();
  final monte = MonteCarloStore();
  BannerAd? _bannerAd;

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';

  /// Loads a banner ad.
  void loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    storePrices.setPrice('BTC-USD');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ListenableBuilder(
          listenable: storePrices,
          builder: (context, w) {
            return storePrices.error
                ? const Center(
                    child: Text('Não foi possível obter os dados'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BTC-USD', style: TextStyle(fontSize: 20)),
                        Row(
                          children: [
                            Text(storePrices.price.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            Text(
                                '(${storePrices.porcent().toStringAsFixed(2)})',
                                style: TextStyle(
                                    color: storePrices.porcent() > 0
                                        ? Colors.green
                                        : Colors.red)),
                          ],
                        ),
                        Text(
                          getPriceMessage(
                            storePrices.porcent(),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ListenableBuilder(
                            listenable: monte,
                            builder: (context, w) {
                              return monte.simulationPaths.isEmpty
                                  ? const SfCartesianChart(
                                      title: ChartTitle(
                                          text:
                                              "Simulação Monte Carlo: Bitcoin",
                                          alignment: ChartAlignment.far),
                                    )
                                  : SizedBox(
                                      height: 400,
                                      child: SfCartesianChart(
                                        title: const ChartTitle(
                                            text:
                                                "Simulação Monte Carlo: Bitcoin",
                                            alignment: ChartAlignment.far),
                                        legend: const Legend(isVisible: false),
                                        primaryXAxis: const NumericAxis(
                                          title: AxisTitle(text: 'Dias'),
                                        ),
                                        primaryYAxis: NumericAxis(
                                          minimum:
                                              monte.finalPrices.first - 10000,
                                          numberFormat: NumberFormat.compact(),
                                        ),
                                        series: monte.simulationPaths
                                            .map((path) =>
                                                LineSeries<ChartPrice, int>(
                                                  animationDelay: 0,
                                                  animationDuration: 0,
                                                  dataSource: path,
                                                  xValueMapper:
                                                      (ChartPrice data, _) =>
                                                          data.day,
                                                  yValueMapper:
                                                      (ChartPrice data, _) =>
                                                          data.price,
                                                  color: Colors.orange
                                                      .withOpacity(0.3),
                                                  width: 1.5,
                                                ))
                                            .toList(),
                                      ),
                                    );
                            }),
                        ListenableBuilder(
                            listenable: monte,
                            builder: (context, w) {
                              return monte.simulationPaths.isEmpty
                                  ? const Card()
                                  : Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Resultados da Simulação",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            ),
                                            const Divider(),
                                            Text(
                                                "5% dos preços simulados são menores que: \$${monte.p5.toStringAsFixed(2)}"),
                                            Text(
                                                "95% dos preços simulados são menores que: \$${monte.p95.toStringAsFixed(2)}"),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Value at Risk (VaR):",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                " - Perda de ${monte.var1.toStringAsFixed(2)}% ou mais com 1% de probabilidade"),
                                            Text(
                                                " - Perda de ${monte.var5.toStringAsFixed(2)}% ou mais com 10% de probabilidade"),
                                          ],
                                        ),
                                      ),
                                    );
                            }),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => monte
                                .runMonteCarloSimulation(storePrices.price),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              // foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: const Text('Simular',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        if (_bannerAd != null)
                          SafeArea(
                            child: SizedBox(
                              width: _bannerAd!.size.width.toDouble(),
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            ),
                          )
                      ],
                    ),
                  );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _bannerAd?.dispose();
  }
}
