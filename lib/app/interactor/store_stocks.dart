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

  Future<void> getStock(String stock, DateTime date) async {
    loading = true;
    error = false;
    selectedTicker = stock;
    notifyListeners();
    final repository = injector.get<DataRepository>();
    final result = await repository.getDate(stock, date);
    result.fold((result) {
      assetModel = result;
    }, (e) {
      error = true;
    });
    loading = false;
    notifyListeners();
  }

  List<ChartData?> chartDataStock() {
    if (assetModel != null) {
      return List.generate(
          assetModel!.dates.length,
          (index) =>
              ChartData(assetModel!.dates[index], assetModel!.prices[index]));
    }
    return [];
  }

  double currentPrice() {
    if (assetModel != null) return assetModel!.prices.last;
    return 0.0;
  }
}
