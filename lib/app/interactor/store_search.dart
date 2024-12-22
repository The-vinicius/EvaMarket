import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/repositories/search_ticker_repository.dart';
import 'package:evamarket/app/repositories/ticker_repository.dart';
import 'package:flutter/foundation.dart';

class StoreSearch extends ChangeNotifier {
  List<Map<String, String>> _stores = [];
  List<Map<String, String>> get stores => _stores;
  bool loading = false;

  void search(String keyword) async {
    loading = true;
    notifyListeners();
    if (keyword.isEmpty) {
      _stores = [];
      return;
    }
    final repository = injector.get<TickerRepository>();
    final result = await repository.fetchAll(keyword);
    result.fold((result) {
      _stores = result;
    }, (error) {
      _stores = [];
    });
    loading = false;
    notifyListeners();
  }
}
