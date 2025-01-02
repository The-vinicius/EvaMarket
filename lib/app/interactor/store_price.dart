import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/repositories/prices_repository.dart';
import 'package:flutter/foundation.dart';

class StorePrice extends ChangeNotifier {
  double _price = 0.0;
  List<double> _prices = [1, 3];
  bool error = false;

  double get price => _price;

  void setPrice(String ticker) async {
    final repository = injector.get<PricesRepository>();
    final result = await repository.getPrices(ticker);
    result.fold((s) => _prices = s, (r) => null);
    _price = _prices[1];
    notifyListeners();
  }

  double porcent() {
    return (_prices[1] - _prices[0]) / _prices[1] * 100;
  }
}
