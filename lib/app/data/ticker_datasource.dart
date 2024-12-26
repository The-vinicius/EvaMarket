import 'dart:convert';

import 'package:evamarket/app/models/ticker_model.dart';
import 'package:flutter/services.dart';

class TickerDatasource {
  Future<List<TickerModel>> getTickers(String query) async {
    final data = await rootBundle.loadString('assets/tickers.json');
    final List<dynamic> json = jsonDecode(data);
    final lowerQuery = query.toLowerCase();
    final _ticker = json.map((e) => TickerModel.fromJson(e)).toList();
    return _ticker.where((ticker) {
      return ticker.symbol.toLowerCase().contains(lowerQuery) ||
          ticker.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
