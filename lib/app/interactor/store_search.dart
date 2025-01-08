import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/models/ticker_model.dart';
import 'package:evamarket/app/repositories/ticker_repository.dart';
import 'package:flutter/foundation.dart';

class StoreSearch extends ChangeNotifier {
  List<TickerModel> _stores = [];
  List<TickerModel> get stores => _stores;
  bool isLoading = false;
  bool get hasError => _stores.isEmpty;
  String get errorMessage => "Pesquisar";

  Future<void> search(String keyword) async {
    isLoading = true;
    notifyListeners();
    if (keyword.isEmpty) {
      _stores = [];
    }
    final repository = injector.get<TickerRepository>();
    final result = await repository.fetchAll(keyword);
    result.fold((result) {
      _stores = result;
    }, (error) {});

    isLoading = false;
    notifyListeners();
  }
}
